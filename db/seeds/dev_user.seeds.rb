DEV_USERNAME = 'dev'

dev = User.find_or_create_by_username(DEV_USERNAME)