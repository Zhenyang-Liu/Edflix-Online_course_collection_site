class Wishlist < Sequel::Model
    set_dataset DB[:wishlists]
    set_primary_key [:user_id, :course_id]

    many_to_one :course, class: :Course, key: :course_id
    many_to_one :user, class: :User, key: :user_id

    def self.add_wishlist(user_id, course_id)
        course = Course.find(course_id: course_id)
        if course
            wishlist = Wishlist.create do |e|
                e.user_id = user_id
                e.course_id = course_id
            end
            return true
        else
            return false
        end
    end

    def self.delete_wishlist(user_id, course_id)
        wishlist = Wishlist.find(user_id: user_id, course_id: course_id)
        if wishlist
            wishlist.destroy
            return true
        else
            return false
        end
    end

    def self.find_record(user_id, course_id)
        record = Wishlist.first(user_id: user_id, course_id: course_id)
        !record.nil?
    end  
end