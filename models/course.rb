class Course < Sequel::Model
    set_dataset DB[:courses]
    one_to_many :enrollments
    
    def load(params, user_id, account_type = "2")
      #takes the params hash and sets the field of the object
        self.course_name = params.fetch("course_name", "").strip
        self.course_description = params.fetch("course_description", "").strip
        self.course_duration = (params.fetch("course_hours", "").to_i * 60) + params.fetch("course_minutes", "").to_i
        self.availability = params.fetch("availability", "").strip
        self.enrollment_link = params.fetch("enrollment_link", "").strip
        self.company = params.fetch("company", "").strip
        self.updated_at = Sequel::CURRENT_TIMESTAMP
        self.updated_by = user_id
        self.topic = params.fetch("topic", "").strip
        
        if params[:course_image] && params[:course_image][:tempfile]
            self.has_image = 1
        else
            self.has_image = 0
        end

        if account_type == "5" || account_type == "6"
            self.trusted = 1
        end
    end

    def save_image(tempfile, course_id)
        # Define the directory where images are saved
        image_directory = "public/img/"

        # Generate a new file name for the image file, using the course number
        new_image_filename = "course_#{course_id}.jpg"

        # Build the full path to the image file
        new_image_path = File.join(image_directory, new_image_filename)

        # Check if an existing image file exists for the course and delete it if it does
        if File.exist?(new_image_path)
            File.delete(new_image_path)
        end

        # Save the uploaded temporary image file to the specified directory with a new file name
        File.open(new_image_path, "wb") do |file|
            file.write(tempfile.read)
        end

        # Find the course object by course_id
        course = Course[course_id]

        # Set the has_image attribute to 1
        course.has_image = 1
        course.save
    end

    def validate
      #goes through the fields and adds messages to an instance field of Course, errors
        super
        errors.add(:course_name, "cannot be empty") if !course_name || course_name.empty?
        errors.add(:course_description, "cannot be empty") if !course_description || course_description.empty?
        errors.add(:course_duration, "must be above or equal 0") if !course_duration || (course_duration < 0)
        errors.add(:availability, "cannot be empty") if !availability || availability.empty?
        errors.add(:enrollment_link, "cannot be empty") if !enrollment_link || enrollment_link.empty?
        errors.add(:company, "cannot be empty") if !company || company.empty?
        errors.add(:topic, "cannot be empty") if !topic || topic.empty?
    end

    def self.load_all_courses
        Course.all
    end

    def self.load_available_courses
        Course.where(availability: 1).all
    end

    def update_course(params, user_id)
        self.set(course_name: params[:course_name],
                 course_duration: params[:course_hours].to_i * 60 + params[:course_minutes].to_i,
                 course_description: params[:course_description],
                 availability: params[:availability].to_i,
                 enrollment_link: params[:enrollment_link],
                 company: params[:company],
                 updated_at: Sequel::CURRENT_TIMESTAMP,
                 updated_by: user_id,
                 topic: params[:topic])
        self.save_changes
    end

    def delete_course
        DB.transaction do
            enrollments = Enrollment.where(course_id: self.id).all

            enrollments.each(&:destroy)

            self.destroy
        end
    end
    
    def get_course_data(params)
        course = Course.where(course_id: params[:id]).first
        if course
            return course.values.to_json
          else
            return { error: "Course not found" }.to_json
        end
    end

    def self.search(query)
        # Assign weights to course name and course description.
        course_name_weight = 4
        course_description_weight = 1
        # Create an empty hash to store courses with their weights.
        courses_with_weight = {}
        
        courses = Course.where(Sequel.ilike(:course_name, "%#{query}%")).where(availability: 1).order(:course_name).all
        # If query length is less than 3, use case-sensitive search for descriptions
        if query.length < 3
            descriptions = Course.where(Sequel.like(:course_description, "%#{query}%")).where(availability: 1).order(:course_name).all
        else
            descriptions = Course.where(Sequel.ilike(:course_description, "%#{query}%")).where(availability: 1).order(:course_name).all
        end
         
        # Add courses found by name search to the courses_with_weight dictionary
        courses.each do |course|
            if !courses_with_weight.has_key?(course.course_id)
                courses_with_weight[course.course_id] = { course: course, weight: course_name_weight }
            end
        end
        # Add courses found by description search to the courses_with_weight dictionary
        # Updating the weight if the course is already in the dictionary
        descriptions.each do |description|
            # Count the number of keyword occurrences in the description
            keyword_count = description.course_description.scan(/#{query}/i).length
            # Calculate the total weight for this course description
            total_description_weight = course_description_weight * keyword_count
            if courses_with_weight.has_key?(description.course_id)
                courses_with_weight[description.course_id][:weight] += total_description_weight
            else
                courses_with_weight[description.course_id] = { course: description, weight: total_description_weight }
            end
        end
        # Convert the dictionary to a list and sort it by weight (descending) and course name (ascending), then map it to only include courses 
        result = courses_with_weight.values
                    .sort_by { |entry| [-entry[:weight], entry[:course][:course_name]] }
                    .map { |entry| entry[:course] }
        result
    end
      
    def self.management_search(query)
        ids = Course.where(course_id: query).order(:course_id)
        courses = Course.where(Sequel.ilike(:course_name, "%#{query}%")).order(:course_id).all
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

    def num_enrollments
        enrollments.count
    end

    def self.company_search(courses, company_name)
        courses.select { |course| course.company == company_name }
    end

    def self.filtered_and_sorted(filter, sort, dataset = nil)
        courses = dataset || self.dataset
    
        case filter
        when 'ALL'
          courses = courses.where(availability: 1)
        when 'Computer Science'
          courses = courses.where(topic: 'Computer Science', availability: 1)
        when 'Biology'
          courses = courses.where(topic: 'Biology', availability: 1)
        when 'Chemistry'
          courses = courses.where(topic: 'Chemistry', availability: 1)
        when 'Physics'
          courses = courses.where(topic: 'Physics', availability: 1)
        when 'Mechanical Engineering'
          courses = courses.where(topic: 'Mechanical Engineering', availability: 1)
        when 'Mathematics'
          courses = courses.where(topic: 'Mathematics', availability: 1)
        when 'History'
          courses = courses.where(topic: 'History', availability: 1)
        when 'Health and Psychology'
          courses = courses.where(topic: 'Health and Psychology', availability: 1)
        when 'Finance'
          courses = courses.where(topic: 'Finance', availability: 1)
        when 'Law and Politics'
          courses = courses.where(topic: 'Law and Politics', availability: 1)
        end
        
    
        case sort
        when 'duration_asc'
          courses = courses.order(Sequel.asc(:course_duration))
        when 'duration_desc'
          courses = courses.order(Sequel.desc(:course_duration))
        when 'rating_asc'
          puts "yes"
          courses = courses.order(Sequel.asc(:average_rating))
        when 'rating_asc'
          courses = courses.order(Sequel.desc(:average_rating))
        end
    
        courses
    end
end

