# MentionSystem

[![Build Status](https://travis-ci.org/pmviva/mention_system.png?branch=master)](https://travis-ci.org/pmviva/mention_system)
[![Gem Version](https://badge.fury.io/rb/mention_system.svg)](http://badge.fury.io/rb/mention_system)
[![Dependency Status](https://gemnasium.com/pmviva/mention_system.svg)](https://gemnasium.com/pmviva/mention_system)
[![Code Climate](https://codeclimate.com/github/pmviva/mention_system/badges/gpa.svg)](https://codeclimate.com/github/pmviva/mention_system)

An active record mention system developed using ruby on rails 5 applying domain driven design and test driven development principles.

For rails 4 support use branch v0.0.7-stable.

This gem is heavily influenced by cmer/socialization.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mention_system'
```

And then execute:

```ruby
$ bundle
```

Or install it yourself as:

```ruby
$ gem install mention_system
```

## Usage

### Run the generator

```ruby
$ rails g mention_system
```

Let's suppose for a moment that you have a blog application and a Post can mention a User or several User models.
The post model becomes the mentioner and the user model becomes the mentionee.

### User object
```ruby
class User < ActiveRecord::Base
  act_as_mentionee

  validates :username, { presence: true, uniqueness: true }
end
```

### Post object
```ruby
class Post < ActiveRecord::Base
  act_as_mentioner

  validates :content, presence: true
end
```

### Mentionee object methods
```ruby
user.is_mentionee? # returns true

user.mentioned_by?(post) # returns true if post mentions the user object, false otherwise

user.mentioners_by(Post) # returns a scope of MentionSystem::Mention join model that belongs to the user object and belongs to mentioner objects of type Post
```


### Mentioner object methods
```ruby
post.is_mentioner? # returns true

post.mention(user) # Creates an instance of MentionSystem::Mention join model associating the post object and the user object, returns true if succeded, false otherwise

post.unmention(user) # Destroys an instance of MentionSystem::Mention join model that associates the post object and the user object, returns true if succeded, false otherwise

post.toggle_mention(user) # Mentions / unmentions the user

post.mentions?(user) # returns true if the post object mentions the user object, false otherwise

post.mentionees_by(User) # returns a scope of MentionSystem::Mention join model that belongs to the post object and belongs to mentionee objects of type User
```

### Mention processors
Mention processors are objects in charge of computing mentions between mentioner objects and mentionee objects.
The framework provides a base mention processor class that the developer should subclass.
Mention processors provide after / before callbacks to hook custom behavior before and after a mention is computed.

Let's suppose we want to parse a post content and process mentions in the form of "@username". We first define a custom mention processor instructing how to compute a post content and how to retrieve a collection of users by the handles mentioned in the post content.

### CustomMentionProcessor object
```ruby
class CustomMentionProcessor < MentionSystem::MentionProcessor
  ###
  # This method returns the content used to parse mentions from the mentioner object, in this case is post's content
  ###
  def extract_mentioner_content(post)
    post.content
  end

  ###
  # This method should return a collection (must respond to each) of mentionee objects for a given set of handles
  # In our case will be a collection of user objects
  ###
  def find_mentionees_by_handles(*handles)
    User.where(username: handles)
  end
end
```

When we call
```ruby
user1 = User.create(username: "test1")
user2 = User.create(username: "test2")
post = Post.create(content: "Post content mentioning @test1 and @test2")

m = CustomMentionProcessor.new
m.process_mentions(post)
```

It will process a mention between "post" and "user1" and also a mention between "post" and "user2".

### Mention processor callbacks
Suppose we want to validate if a user can be mentioned before a mention is processed, we can register a before callback in the mention processor.
Now lets suppose we want to send a notification email when a mention is given to a user, we can register an after callback in the mention processor.

Lets see an example of both:

```ruby
m = CustomMentionProcessor.new

m.add_before_callback Proc.new { |post, user| user.mentions_allowed? }
m.add_after_callback Proc.new { |post, user| UserMailer.notify_mention(post, user) }

m.process_mentions(post)
```

Now when the mention processor process the mentions in the post content, it should validate first if the user is allowed to mention and after the mention is processed an email sent notifying the mention.

You can register several callbacks and they will be called in order.
* When a before callback return false it will not call any further before callback, nor process the mention nor will call any after callbacks.
* When a mention could not be processed none of the after callbacks will be called.
* When an after callback returns false it will not call any further after callback.

You can override the prefix used to parse mentions, it defaults to "@" but you can change to any prefix you like, for example "#", so that mention processors can recognize #test1 and #test2 instead of @user1 and @user2.

To do that you need to override the mention_prefix method in the mention processor.

```ruby
class CustomMentionProcessor < MentionSystem::MentionProcessor
  private:
    ###
    # Defines the mention prefix used to parse mentions, defaults "@"
    ###
    def mention_prefix
      "#"
    end
end
```

For more information read the [api documentation](http://rubydoc.info/gems/mention_system).

## Contributing

1. Fork it ( https://github.com/pmviva/mention_system/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
