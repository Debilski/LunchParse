
import           Control.Monad
import           Control.Monad.IO.Class
import           Data.ByteString.Char8        (putStr)
import           Data.ByteString.UTF8         (fromString)
import           Data.List
import           Data.Random
import           Data.Random.Extras
import           Data.Random.Lift
import           Data.Random.Source.DevRandom
import           Prelude                      hiding (putStr)
import           System.Directory
import           System.FilePath.Find
import           System.IO                    hiding (putStr)

choiceWindow :: Int -> [a] -> RVar [a]
choiceWindow _ [] = return []
choiceWindow size xs = do
  count <- uniform 0 (max (length xs - size) 0)
  return $ take size (drop count xs)


getSnip :: [FilePath] -> Int -> RVarT IO [Char]
getSnip files size =
    lift (choice files) >>= fmap liftIO readFile >>= fmap lift (choiceWindow size)

main = do
    files <- getCurrentDirectory >>= getDirectoryContents >>= filterM (return . isSuffixOf ".txt")
    snip <- runRVarT (getSnip files 500) DevURandom
    putStr $ (fromString (snip ++ "\n"))
    hFlush stdout

