# Types API

Device type API (properties, functions ans statuses).


## Requirements

Types API is tested against MRI 1.9.3.


## Installation 
 
        $ redis-server
        $ git clone git@github.com:lelylan/types.git  && cd types
        $ gem install bundler
        $ bundle install 
        $ foreman start

When installing the service in production set [lelylan environment variables](https://github.com/lelylan/lelylan/blob/master/README.md#production).


## Resources

* [Lelylan Types API](http://dev.lelylan.com/api#api-type)


## Contributing

Fork the repo on github and send a pull requests with topic branches. Do not forget to
provide specs to your contribution.


### Running specs

		$ gem install bundler
        $ bundle install 
        $ bundle exec guard

Press enter to execute all specs.

## Spec guidelines

Follow [betterspecs.org](http://betterspecs.org) guidelines.


## Coding guidelines

Follow [github](https://github.com/styleguide/) guidelines.


## Feedback

Use the [issue tracker](http://github.com/lelylan/types/issues) for bugs or [stack overflow](http://stackoverflow.com/questions/tagged/lelylan) for questions.
[Mail](mailto:dev@lelylan.com) or [Tweet](http://twitter.com/lelylan) us for any idea that can improve the project.


## Links

* [GIT Repository](http://github.com/lelylan/types)
* [Lelylan Dev Center](http://dev.lelylan.com)
* [Lelylan Site](http://lelylan.com)


## Authors

[Andrea Reginato](https://www.linkedin.com/in/andreareginato)


## Contributors

Special thanks to [all people](https://github.com/lelylan/types/graphs/contributors) helping to make the project real.


## Changelog

See [CHANGELOG](https://github.com/lelylan/types/blob/master/CHANGELOG.md)


## License

Lelylan is licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).
