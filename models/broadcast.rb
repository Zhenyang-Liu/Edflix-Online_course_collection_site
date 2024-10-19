class Broadcast < Sequel::Model

    def load(params)
        self.subject = params.fetch("subject", "").strip
        self.content = params.fetch("content", "").strip
    end

    
    def validate
        super
        errors.add("subject", "cannot be empty") if !subject || subject.empty?
        errors.add("content", "cannot be empty") if !content || content.empty?
      end


end