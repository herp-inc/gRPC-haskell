{-# LANGUAGE LambdaCase                      #-}
{-# LANGUAGE OverloadedStrings               #-}
{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
{-# OPTIONS_GHC -fno-warn-unused-binds       #-}

import           Control.Monad
import           Network.GRPC.LowLevel

echoMethod = MethodName "/echo.Echo/DoEcho"

unregistered c = do
  clientRequest c echoMethod 1 "hi" mempty

registered c = do
  meth <- clientRegisterMethod c echoMethod Normal
  clientRegisteredRequest c meth 1 "hi" mempty

run f = withGRPC $ \g -> withClient g (ClientConfig "localhost" 50051) $ \c ->
  f c >>= \case
    Left e -> error $ "Got client error: " ++ show e
    _      -> return ()

main = replicateM_ 100 $ run $
  registered
