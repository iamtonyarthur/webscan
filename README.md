WebScan
=======
WebScan allows you to upload a list of domains (in CSV format) and check whether the websites (at the domains) automatically redirect to HTTPS. It looks for 301 or 302 redirects from a HTTP web request to HTTPS.

It is a fun personal research project. I wrote it when Google Chrome decided to flag websites that use HTTP as "not secure". I was curious to find out which of the Alexa top sites did not have HTTPS.

I have also attached a sample CSV that contains the 150 top domains according to Alexa. It is called "alexa.csv" and it can be found in the root of this repo.

Enjoy!

## Requirements
WebScan is a Ruby on Rails app. It makes use of a Postgres database.

## Installation
First, you will need a working Ruby on Rails environment.

Next, run these commands at the command prompt to create the database and migrate the migrations.
```sh
$ rails db:create db:migrate
```
Once you have created the database, you will need to manually add a user account.

```sh
$ rails console
> u = User.new
> u.email = "your_email@your_domain.io"
> u.passowrd = "some_really_strong_password"
> u.save
```
Next, start the rails server and enjoy WebScan. It was tested with Apple Safari and Google Chrome. Other standards compliant browsers should work too.

```sh
$ rails server
http://localhost:3000
http://localhost:3000/login
```
You will need to login with the password that you created earlier to 1) upload data and 2) run the sub that checks if websites automatically redirect to HTTPS. Once checked, the results are stored in the database and it can be viewed without having to login.

Caveat: Everything you upload data via a csv, WebScan deletes whatever was previously stored in its database.

## Authors

* **Tony** - *Twitter* - [@iamtonyarthur](https://twitter.com/iamtonyarthur)


## Development

Want to contribute? Great!
