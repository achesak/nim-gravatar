# Gravatar API wrapper.

# Written by Adam Chesak.
# Code released under the MIT open source license.

# Import modules.
import httpclient
import strutils
import xmlparser
import xmltree
import streams
import md5


# Define the type.
#type TGravatarProfile*


proc getGravatarHash*(email : string): string = 
    ## Gets the gravatar hash for email.
    
    return getMD5(email)


proc getGravatarImage*(hash : string): string = 
    ## Gets the image URL specified by hash.
    
    return "http://www.gravatar.com/avatar/" & hash


proc downloadGravatarImage*(hash : string, filename : string): string = 
    ## Downloads the image specified by hash. Returns the remote URL.
    
    # Create the URL.
    var url : string = "http://www.gravatar.com/avatar/" & hash

    # Download the image.
    downloadFile(url, filename)
    
    return url
    

proc getGravatarProfile*(user : string): string = #: TGravatarProfile = 
    ## Gets the specified user's profile.


proc getGravatarQR*(user : string): string = 
    ## Gets the image URL for the user's QR code.
    
    return "http://www.gravatar.com/" & user & ".qr"


proc downloadGravatarQR*(user : string, filename : string): string = 
    ## Downloads the user's QR code. Returns the remote URL.
    
    # Create the URL.
    var url : string = "http://www.gravatar.com/" & user & ".qr"
    
    # Download the image.
    downloadFile(url, filename)
    
    return url
