{-# LANGUAGE EmptyDataDecls, ForeignFunctionInterface #-}

module Data.LinearProgram.GLPK.Types where

import Control.Monad.Trans (MonadIO (..))

import Foreign.Ptr
import Foreign.ForeignPtr

foreign import ccall unsafe "c_glp_create_prob" glpCreateProb :: IO (Ptr GlpProb)
foreign import ccall unsafe "&c_glp_delete_prob" glpDelProb :: FunPtr (Ptr GlpProb -> IO ())

data GlpProb

data ReturnCode = Success | InvalidBasis | SingularMatrix | IllConditionedMatrix | 
	InvalidBounds | SolverFailed | ObjLowerLimReached | ObjUpperLimReached | 
	IterLimReached | TimeLimReached | NoPrimalFeasible | NoDualFeasible | RootLPOptMissing |
	SearchTerminated | MipGapTolReached | NoPrimDualFeasSolution | NoConvergence |
	NumericalInstability | InvalidData | ResultOutOfRange deriving (Eq, Show, Enum)

gaveAnswer :: ReturnCode -> Bool
gaveAnswer = flip elem [Success, IterLimReached, TimeLimReached, SearchTerminated, MipGapTolReached]

newtype GLPK a = GLP {execGLPK :: Ptr GlpProb -> IO a}

runGLPK :: GLPK a -> IO a
runGLPK m = do	lp <- newForeignPtr glpDelProb =<< glpCreateProb
		withForeignPtr lp (execGLPK m)

instance Monad GLPK where
	{-# INLINE return #-}
	{-# INLINE (>>=) #-}
	return x = GLP $ \ _ -> return x
	m >>= k = GLP $ \ lp -> do	x <- execGLPK m lp
					execGLPK (k x) lp

instance MonadIO GLPK where
	liftIO m = GLP (const m)

data MsgLev = MsgOff | MsgErr | MsgOn | MsgAll deriving (Eq, Enum, Read, Show)
data BranchingTechnique = FirstFrac | LastFrac | MostFrac | DrTom | HybridP deriving (Eq, Enum, Read, Show)
data BacktrackTechnique = DepthFirst | BreadthFirst | LocBound | ProjHeur deriving (Eq, Enum, Read, Show)
data Preprocessing = NoPre | RootPre | AllPre deriving (Eq, Enum, Read, Show)
data Cuts = GMI | MIR | Cov | Clq deriving (Eq, Enum, Read, Show)
