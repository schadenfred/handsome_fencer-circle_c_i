# HandsomeFencer::CircleCI

This gem provides developers a handsome way of deploying applications using Docker, CircleCI, and the server of their choice. It's written in Ruby, uses Thor, and admires the Rails philosophy of convention over configuration.

## Usage

Once installed, handsome_fencer-circle_c_i gives you a CLI with four commands -- install, generate_key, obfuscate, and expose:

```bash
$ handsome_fencer-circle_c_i --help
```

## Installation

If you just need to generate keys, obfuscate, or expose, environment files:

```bash
$ gem install handsome_fencer-circle_c_i
```

## Using install command with Docker and Docker Compose

If you wish to use the install command, you'll need Docker and Docker Compose installed.

[installing Docker](https://docs.docker.com/install/)
[installing Docker Compose](https://docs.docker.com/compose/install/)

Once you can do:

```bash
$ docker-compose -v
```

...and see output similar to:

```bash
$ docker-compose -v
docker-compose version 1.21.0, build 5920eb0
```

...You are now ready to either a) greenfield a handsome new app or b) handsomize an existing one.


## Greenfielding a fully dockerized Rails application:

1) Execute the install command:

```bash
$ handsome_fencer-circle_c_i dockerize
```

2) Ask Docker to use Rails to generate our dockerized Rails app:

```bash
$ docker-compose run app rails new .
```

If you're on a linux machine, you may need to chown the newly created files:

```bash
$ sudo chown <username><user group> -R .
```

If that doesn't work, Docker's [documentation](https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user) should get you pointed in the right direction.

3) Ask Docker to build the necessary images for our app and spool up containers using them:

```bash
$ docker-compose up --build
 ```

4) Ask Docker to set up our database bye executing the following commands within the container for our Rails app:

 ```bash
 $ docker-compose exec app bin/rails db:create db:migrate
  ```

You should now be able to see the Rails welcome screen upon clicking [http://localhost:3000/](http://localhost:3000/).

## Dockerizing an existing Rails application:

1) Execute the install command:

```bash
$ handsome_fencer-circle_c_i install
```

2) You'll be asked which files to write over. Keep your Gemfile and let it write over everything else, including your .gitignore, any existing docker-compose.yml, .circleci/config.yml, and Gemfile.lock files.

3) Ask Docker to build the necessary images for our app and spool up containers using them:

```bash
$ docker-compose up --build
 ```

If you're on a linux machine, you may need to chown the newly created files using:

```bash
$ sudo chown <username><user group> -R .
```

If that doesn't work, Docker's [documentation](https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user) should get you pointed in the right direction.

4) Ask Docker to set up your database by executing the following commands inside the app container:

 ```bash
 $ docker-compose exec app bin/rails db:setup
  ```

You should now be able to see your app running upon clicking [http://localhost:3000/](http://localhost:3000/).


## Contributing

This gem and the associated practices are just a way of deploying your application, not the canonical or best way. If you have suggestions on how to make it easier, more secure, quicker or better, please share them. If you have specific ideas, please fork the repo, make your changes, write your tests, and send me a pull request.    

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
