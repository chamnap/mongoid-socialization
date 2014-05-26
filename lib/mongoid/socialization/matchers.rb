module Mongoid
  module Socialization
    module Shoulda
      module Matchers

        def be_a_liker
          BeALiker.new
        end

        def be_a_likeable
          BeALikeable.new
        end

        def be_a_follower
          BeAFollower.new
        end

        def be_a_followable
          BeAFollowable.new
        end

        def be_a_wish_lister
          BeAWishLister.new
        end

        def be_a_wish_listable
          BeAWishListable.new
        end

        def be_a_mentioner
          BeAMentioner.new
        end

        def be_a_mentionable
          BeAMentionable.new
        end

        class BeALiker
          attr_accessor :klass

          def matches?(instance)
            self.klass = instance.class
            klass.liker?
          end

          def failure_message
            "Expected to call `include Mongoid::Socialiation::Liker` inside #{klass}"
          end

          def description
            "require to call `include Mongoid::Socialiation::Liker` inside #{klass}"
          end
        end

        class BeALikeable
          attr_accessor :klass

          def matches?(instance)
            self.klass = instance.class
            klass.likeable?
          end

          def failure_message
            "Expected to call `include Mongoid::Socialiation::Likeable` inside #{klass}"
          end

          def description
            "require to call `include Mongoid::Socialiation::Likeable` inside #{klass}"
          end
        end

        class BeAFollower
          attr_accessor :klass

          def matches?(instance)
            self.klass = instance.class
            klass.follower?
          end

          def failure_message
            "Expected to call `include Mongoid::Socialiation::Follower` inside #{klass}"
          end

          def description
            "require to call `include Mongoid::Socialiation::Follower` inside #{klass}"
          end
        end

        class BeAFollowable
          attr_accessor :klass

          def matches?(instance)
            self.klass = instance.class
            klass.followable?
          end

          def failure_message
            "Expected to call `include Mongoid::Socialiation::Followable` inside #{klass}"
          end

          def description
            "require to call `include Mongoid::Socialiation::Followable` inside #{klass}"
          end
        end

        class BeAWishLister
          attr_accessor :klass

          def matches?(instance)
            self.klass = instance.class
            klass.wish_lister?
          end

          def failure_message
            "Expected to call `include Mongoid::Socialiation::WishLister` inside #{klass}"
          end

          def description
            "require to call `include Mongoid::Socialiation::WishLister` inside #{klass}"
          end
        end

        class BeAWishListable
          attr_accessor :klass

          def matches?(instance)
            self.klass = instance.class
            klass.wish_listable?
          end

          def failure_message
            "Expected to call `include Mongoid::Socialiation::WishListable` inside #{klass}"
          end

          def description
            "require to call `include Mongoid::Socialiation::WishListable` inside #{klass}"
          end
        end

        class BeAMentioner
          attr_accessor :klass

          def matches?(instance)
            self.klass = instance.class
            klass.mentioner?
          end

          def failure_message
            "Expected to call `include Mongoid::Socialiation::Mentioner` inside #{klass}"
          end

          def description
            "require to call `include Mongoid::Socialiation::Mentioner` inside #{klass}"
          end
        end
      end

      class BeAMentionable
        attr_accessor :klass

        def matches?(instance)
          self.klass = instance.class
          klass.mentionable?
        end

        def failure_message
          "Expected to call `include Mongoid::Socialiation::Mentionable` inside #{klass}"
        end

        def description
          "require to call `include Mongoid::Socialiation::Mentionable` inside #{klass}"
        end
      end
    end
  end
end

require "rspec/core"
RSpec.configure do |config|
  config.include Mongoid::Socialiation::Shoulda::Matchers
end