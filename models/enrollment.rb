class Enrollment < Sequel::Model
    set_dataset DB[:enrollments]
    set_primary_key [:user_id, :course_id]

    many_to_one :course, class: :Course, key: :course_id
    many_to_one :user, class: :User, key: :user_id

    def self.add_enrollment(user_id, course_id)
        course = Course.find(course_id: course_id)
        if course
            enrollment = Enrollment.create do |e|
                e.user_id = user_id
                e.course_id = course_id
                e.is_completed = 0
                e.start_date = Sequel::CURRENT_TIMESTAMP
            end
            return true
            
        else
            return false
        end
    end

    def self.delete_enrollment(user_id, course_id)
        enrollment = Enrollment.find(user_id: user_id, course_id: course_id)
        if enrollment
            enrollment.destroy
            return true
        else
            return false
        end
    end
    
    def self.mark_course_completed(user_id, course_id)
        enrollment = Enrollment.find(user_id: user_id, course_id: course_id)
        if enrollment
            enrollment.is_completed = 1
            enrollment.completed_date = Sequel::CURRENT_TIMESTAMP
            enrollment.save_changes
            return true
        else
            return false
        end
    end

    def self.mark_course_incompleted(user_id, course_id)
        enrollment = Enrollment.find(user_id: user_id, course_id: course_id)
        if enrollment
            enrollment.is_completed = 0
            enrollment.completed_date = nil
            enrollment.save_changes
            return true
        else
            return false
        end
    end

    def self.for_user(user_id)
        where(user_id: user_id)
    end

    def self.find_record(user_id, course_id)
        record = Enrollment.first(user_id: user_id, course_id: course_id)
        !record.nil?
    end
    
end