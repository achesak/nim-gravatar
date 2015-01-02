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


# Define the types.
type GravatarPhoto* = tuple[value : string, photoType : string]

type GravatarProfile* = tuple[id : string, hash : string, requestHash : string, profileUrl : string,
                               preferredUsername : string, thumbnailUrl : string, photos : seq[GravatarPhoto],
                               profileColor : string, profilePosition : string, profileRepeat : string, 
                               profileBackground : string, givenName : string, familyName : string,
                               formattedName : string, displayName : string, aboutMe : string, location : string]


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
    

proc getGravatarProfile*(user : string): GravatarProfile = 
    ## Gets the specified user's profile.
    
    # Get the data.
    var response : string = getContent("http://www.gravatar.com/" & user & ".xml")
    
    # Parse the data into XML.
    var xml : XmlNode = parseXML(newStringStream(response)).child("entry")
    
    # Create the return object.
    var profile : GravatarProfile
    
    # Populate the return object.
    profile.id = xml.child("id").innerText
    profile.hash = xml.child("hash").innerText
    profile.requestHash = xml.child("requestHash").innerText
    profile.profileUrl = xml.child("profileUrl").innerText
    profile.preferredUsername = xml.child("preferredUsername").innerText
    if xml.child("thumbnailUrl") != nil:
        profile.thumbnailUrl = xml.child("thumbnailUrl").innerText
    if xml.child("photos") != nil:
        var photosXML : seq[XmlNode] = xml.findall("photos")
        var photos = newSeq[GravatarPhoto](len(photosXML))
        for i in 0..high(photosXML):
            var item : GravatarPhoto
            item.value = photosXML[i].child("value").innerText
            if photosXML[i].child("type") != nil:
                item.photoType = photosXML[i].child("type").innerText
            photos[i] = item
        profile.photos = photos
    var bg : XmlNode = xml.child("profileBackground")
    if bg.child("color") != nil:
        profile.profileColor = bg.child("color").innerText
    if bg.child("position") != nil:
        profile.profilePosition = bg.child("position").innerText
    if bg.child("repeat") != nil:
        profile.profileRepeat = bg.child("repeat").innerText
    if bg.child("url") != nil:
        profile.profileBackground = bg.child("url").innerText
    var name : XmlNode = xml.child("name")
    if name.child("givenName") != nil:
        profile.givenName = name.child("givenName").innerText
    if name.child("familyName") != nil:
        profile.familyName = name.child("familyName").innerText
    if name.child("formatted") != nil:
        profile.formattedName = name.child("formatted").innerText
    if xml.child("displayName") != nil:
        profile.displayName = xml.child("displayName").innerText
    if xml.child("aboutMe") != nil:
        profile.aboutMe = xml.child("aboutMe").innerText
    if xml.child("currentLocation") != nil:
        profile.location = xml.child("currentLocation").innerText
    
    # Return the profile data.
    return profile


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
