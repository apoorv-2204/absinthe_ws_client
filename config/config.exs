import Config
config :absinthe_client, :src_dir, File.cwd!()

config :absinthe_client, :mut_dir, "data"

import_config("#{Mix.env()}.exs")
