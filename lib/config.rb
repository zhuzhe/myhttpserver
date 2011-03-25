# To change this template, choose Tools | Templates
# and open the template in the editor.

module Config
  
  LIBDIR = File::dirname(__FILE__)

  General = {
    :Host => "127.0.0.1",
    :Port => 80,
    :MaxClients => 100,
    :ServerType => nil,
    :Logger => nil,
    :ServerSoftware => "Light",
    :Max_Size => 20,
    :Max_Size_Per_Process => 500
  }

  HTTP =  General.dup.update(
    :HTTPVersion => 1.1,
    :RequestTimeout => 30
  )
    
end
