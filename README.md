# Development Infrastructure

I've got various personal projects I want to take on, and I wanted to have a development environment for them, both for doing CI based builds and deployments, and also for some project management to help me keep track of things. Before taking on any of these projects, I wanted to have a pretty decent level of automation and disaster recovery in place for the environment. It's going to run on AWS, but I also want to keep it relatively provider agnostic.

This is a Puppet based repository to stand up that environment. It uses the very nice [roles and profiles pattern](http://www.craigdunn.org/2012/05/239/), which provides a nice abstraction model that makes it very easy to build new boxes and extend existing ones. As of yet, there aren't any rspec based tests, but I'll definitely add those soon, as TDD with Puppet is something I'm keen to learn. At the moment, this setup uses Puppet in masterless mode, using Packer to build all the AMIs. In the future, I might go for a master based setup with an External Node Classifier, but for the time being, I'm going to stick to this relatively simple setup. There are a bunch of Vagrant configurations for bringing the machines online, but this is short term; pretty soon I think I'm going to use CloudFormation to bring the stack online.

List of the infrastructure that's automated:

* Postgres 9.3 for the JIRA backend. A cron job dumps the database contents out every night and uploads that backup to S3.
* JIRA 6.27 with Postgres backend. A cron job backs up the JIRA home directory every night and uploads that backup to S3. I used JIRA many years ago at my old work, and back then didn't really like it too much, but I've started using it recently at a new place, and it's came such a long way; I really like it now. It's so cheap to get a personal license, I figured I'd just setup my own instance for keeping track of my projects.
