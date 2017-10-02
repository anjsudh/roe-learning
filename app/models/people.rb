class People < ActiveRecord::Base
  attr_accessor :gender, :grade, :role, :inBeach

  def gender=(value)
    self[:gender] = value == 'Man' ? 0 : 1
  end

  def grade=(value)
    self[:grade] = if value == 'Con - Grad'
                     1
                   elsif value == 'Con'
                     2
                   elsif value == 'Sr Con'
                     3
                   elsif value == 'Lead Con'
                     4
                   elsif value == 'Prin Con'
                     5
                   elsif value == 'Sr Assoc'
                     6
                   else
                     0
                   end
  end

  def role(value)
    self[:grade] = if value == 'Dev'
                     1
                   elsif value == 'BA'
                     2
                   elsif value == 'PM'
                     3
                   elsif value == 'XD'
                     4
                   elsif value == 'QA'
                     5
                   else
                     0
                   end
  end

  def inBeach=(value)
    self[:inBeach] = (value == '')
  end
end
