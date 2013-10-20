# Gravatar API wrapper.

# Written by Adam Chesak.
# Code released under the MIT open source license.

# Import modules.
import httpclient
import strutils
import xmlparser
import xmltree
import streams


# Define the type.
#type TGravatar*


proc getImage*(hash : string): string = 
    ## Gets the image specified by hash.


proc getProfile*(user : string): string = #: TGravatar = 
    ## Gets the specified user's profile.