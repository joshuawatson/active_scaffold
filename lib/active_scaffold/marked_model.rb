module ActiveScaffold
  module MarkedModel
    # This is a module aimed at making the make session_stored marked_records available to ActiveRecord models
    
    def self.included(base)
      base.class_eval do
        extend ClassMethods
        scope :as_marked, lambda { where(primary_key => marked_record_ids) }
      end
    end
    
    def as_marked
      marked_records.include?(self.id.to_s)
    end
    
    def as_marked=(value)
      value = [true, 'true', 1, '1', 'T', 't'].include?(value.class == String ? value.downcase : value)
      if value == true
        marked_records[self.id.to_s] = true if !as_marked
      else
        marked_records.delete(self.id.to_s)
      end
    end
  
    module ClassMethods
      def marked_records
        Thread.current[:marked_records] ||= {}
      end

      def marked_records=(marked)
        Thread.current[:marked_records] = marked 
      end

      def marked_record_ids
        marked_records.keys
      end
    end
  
    # Instance-level access to the marked_records
    def marked_records
      self.class.marked_records
    end
  end
end
