class Courses_waiting_list < Sequel::Model
    set_dataset DB[:courses_waiting_lists]

    def load(params)
        #takes the params hash and sets the field of the object
        self.course_name = params.fetch("course_name", "").strip
        self.course_description = params.fetch("course_description", "").strip
        self.course_duration = (params.fetch("course_hours", "").to_i * 60) + params.fetch("course_minutes", "").to_i
        self.enrollment_link = params.fetch("enrollment_link", "").strip
        self.company = params.fetch("company", "").strip
        self.availability = "0"
        self.updated_at = Sequel::CURRENT_TIMESTAMP
    end

    def validate
        #goes through the fields and adds messages to an instance field of Course, errors
        super
        errors.add(:course_name, "cannot be empty") if !course_name || course_name.empty?
        errors.add(:enrollment_link, "cannot be empty") if !enrollment_link || enrollment_link.empty?
    end

    def self.load_all_courses
        Courses_waiting_list.all
    end

    def get_course_data(params)
        course = Courses_waiting_list.where(course_id: params[:id]).first
        if course
            return course.values.to_json
          else
            return { error: "Course not found" }.to_json
        end
    end

    def delete_course
       self.destroy
    end

    def self.management_search(query)
        ids = Courses_waiting_list.where(course_id: query).order(:course_id)
        courses = Courses_waiting_list.where(Sequel.ilike(:course_name, "%#{query}%")).order(:course_id).all
        result = []
        ids.each do |id|
          result << id
          courses.delete(id)
        end
        courses.each do |course|
          result << course
        end
        result
    end
    
end