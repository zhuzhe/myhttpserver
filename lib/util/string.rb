# To change this template, choose Tools | Templates
# and open the template in the editor.

class String

  def to_16
    self.unpack("U*").collect{|i| "ox#{i.to_s(16)}"}
  end

end
