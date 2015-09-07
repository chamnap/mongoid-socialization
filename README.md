# Mongoid::Socialization
[![Build Status](https://travis-ci.org/chamnap/mongoid-socialization.svg?branch=master)](https://travis-ci.org/chamnap/mongoid-socialization)[![Dependency Status](https://gemnasium.com/chamnap/mongoid-socialization.svg)](https://gemnasium.com/chamnap/mongoid-socialization)

Mongoid-Socialization allows your mongoid models to `Like`, `Follow`, `WishList`, `Mention`, `Message` any other mongoid models. It supports both `mongoid` 3 and 4. Basically, it's inspired by [socialization](https://github.com/cmer/socialization) from [cmer](https://github.com/cmer), but it supports only ActiveRecord and Redis. Unlike [socialization](https://github.com/cmer/socialization), **mongoid-socialization** has more functionalities and I hope to extend them more.

## Installation

Add this line to your application's Gemfile:

    gem 'mongoid-socialization'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid-socialization

#### Mongoid 4

You need to add [mongoid-observers](https://rubygems.org/gems/mongoid-observers) into your Gemfile:

    gem 'mongoid-observers'

## Usage

Mongoid-Socialization's composed of 4 modules:

* **Like**: It works just like a Facebook Like. For example, Chamnap likes [Snappyshop](http://facebook.com/snappyshop).

```ruby
# app/models/user.rb
class User
  include Mongoid::Document
  include Mongoid::Socialization::Liker
end

# app/models/page.rb
class Page
  include Mongoid::Document
  include Mongoid::Socialization::Likeable
end
```

`Mongoid::Socialization::Liker` module

    user.like!(page)
    user.unlike!(page)
    user.toggle_like!(page)
    user.liked?(page)
    user.likeables(Page)
    user.likeable_ids(User)

`Mongoid::Socialization::Likeable` module

    page.liked_by?(user)
    page.likers(User)
    page.liker_ids(User)
    page.likers_count(User)

* **Follow**: is a one-way concept, similar to Twitter's follow. For example, Chamnap follows Vorleak. It doesn't mean that Vorleak follows Chamnap. However, Vorleak can follow Chamnap back if he want to.

```ruby
# app/models/user.rb
class User
  include Mongoid::Document
  include Mongoid::Socialization::Follower
end

# app/models/page.rb
class Page
  include Mongoid::Document
  include Mongoid::Socialization::Followable
end
```

`Mongoid::Socialization::Follower` module

    user.follow!(page)
    user.unfollow!(page)
    user.toggle_follow!(page)
    user.followed?(page)
    user.followings(Page)
    user.followings_ids(Page)
    user.followings_count(Page)

`Mongoid::Socialization::Followable` module

    page.followed_by?(user)
    page.followers(User)
    page.follower_ids(User)
    page.followers_count(User)

* **WishList**: It's similar to the like module. It's just a collection of your users' favorite things.

```ruby
# app/models/user.rb
class User
  include Mongoid::Document
  include Mongoid::Socialization::WishLister
end

# app/models/product.rb
class Product
  include Mongoid::Document
  include Mongoid::Socialization::WishListable
end
```

`Mongoid::Socialization::WishLister` module

    user.wish_list!(page)
    user.unwish_list!(page)
    user.toggle_wish_list!(page)
    user.wish_listed?(page)
    user.wish_listables(Page)
    user.wish_listable_ids(Page)

`Mongoid::Socialization::WishListable` module

    page.wish_listed_by?(user)
    page.wish_listers(User)
    page.wish_lister_ids(User)
    page.wish_listers_count(User)

* **Mention**: very similar to Facebook mentions. For example, Chamnap mentions Vorleak in his comment. A "mentioner" is the object containing the mention, not the actor. In this example, mentioner is the comment object, NOT Chamnap.

```ruby
# app/models/user.rb
class User
  include Mongoid::Document
  include Mongoid::Socialization::Mentionable
end

# app/models/comment.rb
class Comment
  include Mongoid::Document
  include Mongoid::Socialization::Mentioner
end
```

`Mongoid::Socialization::Mentioner` module

    comment.mention!(user)
    comment.unmention!(user)
    comment.toggle_mention!(user)
    comment.mentioned?(user)
    comment.mentionables(User)
    comment.mentionable_ids(User)

`Mongoid::Socialization::Mentionable` module

    user.mentioned_by?(comment)
    user.mentioners(Comment)
    user.mentioner_ids(Comment)
    user.mentioners_count(Comment)

* **Private Message**

## Authors

* [Chamnap Chhorn](https://github.com/chamnap)
