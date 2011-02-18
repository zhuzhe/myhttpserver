


module HttpUtil

  CR = "\x0d"
  LF = "\x0a"
  CRLF = "\x0d\x0a"

  DefaultMimeTypes = {
    "ai"    => "application/postscript",
    "asc"   => "text/plain",
    "avi"   => "video/x-msvideo",
    "bin"   => "application/octet-stream",
    "bmp"   => "image/bmp",
    "class" => "application/octet-stream",
    "cer"   => "application/pkix-cert",
    "crl"   => "application/pkix-crl",
    "crt"   => "application/x-x509-ca-cert",
    #"crl"   => "application/x-pkcs7-crl",
    "css"   => "text/css",
    "dms"   => "application/octet-stream",
    "doc"   => "application/msword",
    "dvi"   => "application/x-dvi",
    "eps"   => "application/postscript",
    "etx"   => "text/x-setext",
    "exe"   => "application/octet-stream",
    "gif"   => "image/gif",
    "htm"   => "text/html",
    "html"  => "text/html",
    "jpe"   => "image/jpeg",
    "jpeg"  => "image/jpeg",
    "jpg"   => "image/jpeg",
    "lha"   => "application/octet-stream",
    "lzh"   => "application/octet-stream",
    "mov"   => "video/quicktime",
    "mpe"   => "video/mpeg",
    "mpeg"  => "video/mpeg",
    "mpg"   => "video/mpeg",
    "pbm"   => "image/x-portable-bitmap",
    "pdf"   => "application/pdf",
    "pgm"   => "image/x-portable-graymap",
    "png"   => "image/png",
    "pnm"   => "image/x-portable-anymap",
    "ppm"   => "image/x-portable-pixmap",
    "ppt"   => "application/vnd.ms-powerpoint",
    "ps"    => "application/postscript",
    "qt"    => "video/quicktime",
    "ras"   => "image/x-cmu-raster",
    "rb"    => "text/plain",
    "rd"    => "text/plain",
    "rtf"   => "application/rtf",
    "sgm"   => "text/sgml",
    "sgml"  => "text/sgml",
    "tif"   => "image/tiff",
    "tiff"  => "image/tiff",
    "txt"   => "text/plain",
    "xbm"   => "image/x-xbitmap",
    "xhtml" => "text/html",
    "xls"   => "application/vnd.ms-excel",
    "xml"   => "text/xml",
    "xpm"   => "image/x-xpixmap",
    "xwd"   => "image/x-xwindowdump",
    "zip"   => "application/zip",
  }

  def  parse_header raw_header
    header = {}
    raw_header.split(CRLF).each_with_index do |item, index|
      if index == 0
        header["request_method"], header["request_uri"], header["http_version"] = item.split(" ")
      else
        key, value = item.split(":")
        header[key.downcase] = value.strip
      end
    end
    header
  end

  module_function :parse_header

end
