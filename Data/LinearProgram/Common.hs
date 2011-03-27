-- | Contains sufficient tools to represent linear programming problems in Haskell.  In the future, if linkings to other
-- linear programming libraries are made, this will be common to them all.
module Data.LinearProgram.Common (
	module Data.LinearProgram.Spec,
	module Data.Algebra,
	module Data.LinearProgram.Types) where

import Data.LinearProgram.Spec
import Data.Algebra
import Data.LinearProgram.Types

import Data.Map