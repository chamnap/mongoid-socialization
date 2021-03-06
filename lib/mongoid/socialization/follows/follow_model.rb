module Mongoid
  module Socialization
    module FollowModel
      extend ActiveSupport::Concern

      included do

        # Indexes
        index({ followable_id: 1, followable_type: 1 }, { background: true })
        index({ follower_id: 1, follower_type: 1 }, { background: true })

        # Relations
        belongs_to  :follower,          polymorphic: true
        belongs_to  :followable,        polymorphic: true

        # Scopes
        scope :followed_by, ->(follower) {
          where(follower_type: follower.class.name, follower_id: follower.id)
        }

        scope :following,   ->(followable) {
          where(followable_type: followable.class.name, followable_id: followable.id)
        }
      end

      module ClassMethods
        def follow!(follower, followable)
          return false if followed?(follower, followable)

          create!(follower: follower, followable: followable)
          follower.update_followings_count!(followable.class, followables(follower, followable.class).size)
          followable.update_followers_count!(follower.class, followers(followable, follower.class).size)
          true
        end

        def unfollow!(follower, followable)
          return false unless followed?(follower, followable)

          follow_for(follower, followable).delete_all
          follower.update_followings_count!(followable.class, followables(follower, followable.class).size)
          followable.update_followers_count!(follower.class, followers(followable, follower.class).size)
          true
        end

        def toggle_follow!(follower, followable)
          if followed?(follower, followable)
            unfollow!(follower, followable)
          else
            follow!(follower, followable)
          end
        end

        def followed?(follower, followable)
          validate_follower!(follower)
          validate_followable!(followable)

          follow_for(follower, followable).present?
        end

        def followables(follower, klass)
          validate_follower!(follower)
          validate_followable!(klass)

          followable_ids = only(:followable_id).
            where(followable_type: klass.name).
            where(follower_type: follower.class.name).
            where(follower_id: follower.id).
            collect(&:followable_id)
          klass.where(:_id.in => followable_ids)
        end

        def followers(followable, klass)
          validate_follower!(klass)
          validate_followable!(followable)

          follower_ids = only(:follower_id).
            where(follower_type: klass.name).
            where(followable_type: followable.class.name).
            where(followable_id: followable.id).
            collect(&:follower_id)
          klass.where(:_id.in => follower_ids)
        end

        def remove_followables(follower)
          where(follower_type: follower.class.name, follower_id: follower.id).delete_all
        end

        def remove_followers(followable)
          where(followable_type: followable.class.name, followable_id: followable.id).delete_all
        end

        def follow_for(follower, followable)
          followed_by(follower).following(followable)
        end

        def validate_follower!(follower)
          raise Socialization::Error.new(follower, "is not a follower")      unless follower.respond_to?(:follower?) && follower.follower?
        end

        def validate_followable!(followable)
          raise Socialization::Error.new(followable, "is not a followable")  unless followable.respond_to?(:followable?) && followable.followable?
        end
      end
    end
  end
end