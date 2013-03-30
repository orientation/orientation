class Revision < ActiveRecord::Base
  belongs_to :editor, class_name: "User"
end
