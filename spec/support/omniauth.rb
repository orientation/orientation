OmniAuth.config.test_mode = true
omniauth_hash = { 'uid' => '777777', 'name' => 'mockuser' }

OmniAuth.config.add_mock(:google_oauth2, omniauth_hash)

