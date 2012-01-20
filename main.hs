import Yesod.Default.Config (fromArgs)
import Yesod.Default.Main   (defaultMain)
import Application          (withJabaraster)
import Prelude              (IO)

main :: IO ()
main = defaultMain fromArgs withJabaraster