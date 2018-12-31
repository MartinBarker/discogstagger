class WelcomeController < ApplicationController
  def index
  end

  def superman
    print "in superman"
    value1 = params[:value1] #url_release_id
    value2 = params[:value2]
    
    require 'discogs-wrapper'
    wrapper = Discogs::Wrapper.new("shop")

    release = wrapper.get_release(value1) 
    
    print "\nbegin\n\n"
    print release 
print "\n\n"
tags = Array[]
tags.push(release.title)
print "initial title tags = ", tags , "\n"


 
releaseArtists = Array[]
unless release.artists.nil? || release.artists == 0
    #"release.artists" is not null
    #iterate through each band/artist in a listing
    $i = 0
    while $i < release.artists.count do 
        print "artistsCount loop, total count = ", release.artists.count , "\n"
        #print release.artists[$i], "\n"
        $artistID = release.artists[$i]['id']
        #iterate through each artist in a band / get their info
        $artistTags = getArtistTags($artistID)
        #tags.push($artistTags)
        $artistName = release.artists[$i]['name']
        releaseArtists.push($artistName)
        tags = combineMaps(tags, $artistTags)
        #print "artistTags = ", $artistTags, " \n" 
        $i += 1
    end 
end
print "after artist tags = ", tags , "\n"


#get combination of releaseName / artist(s) / year / label / "full album", "youtube"
$year = release['year']

if $year == 0
#    print "year==0\n"
    $year = ""
else 
    tags.push($year)
end
print "year = ", $year, "\n"
print "year tags = ", tags , "\n"

$titleCombination = stringifyMap(releaseArtists, 1) + ' ' + release.title + ' ' + $year.to_s  
tags.push($titleCombination)
print "title combination tags = ", tags , "\n"
print "\n**\n"

unless release.country.nil? || release.country == 0
    #release.country is not null
    tags.push(release.country)
end

print "release.labels.count = ", release.labels.count, "\n"
unless release.labels.nil? || release.labels == 0
    #release.labels is not null
    print release.labels   
    $x = 0
    while $x < release.labels.count do 
        $labelID = release.labels[$x]['id']
        $labelName  = release.labels[$x]['name']
        tags.push($labelName)
        
        #deeper dive into label based on id?
        $x += 1
    end 
end

#print "release.genres = ", release.genres, " \n"
unless release.genres.nil? || release.genres == 0
    #release.genres is not null
    $x = 0
    while $x < release.genres.count do 
        tags.push(release.genres[$x])
        $x += 1
    end 
end 

#print "release.styles = ", release.styles, " \n"
unless release.styles.nil? || release.styles == 0
    #release.styles is not null
    $x = 0
    while $x < release.styles.count do 
        tags.push(release.styles[$x])
        $x += 1
    end 
end 

#print "\nrelease.formats = ", release.formats, "\n"
#print "\nrelease.formats[0] = ", release.formats[0], "\n"
#print "release.formats[0][descriptions] = ", release.formats[0]['descriptions'], "\n"
unless release.formats.nil? || release.formats == 0
    #release.formats is not null
    $x = 0
    while $x < release.formats.count do 
        unless release.formats[$x]['descriptions'].nil? || release.formats[$x]['descriptions'] == 0
            #release.formats[$x]['descriptions'] is not null 
            $p = 0
            while $p < release.formats[$x]['descriptions'].count do 
                tags.push(release.formats[$x]['descriptions'][$p])
                $p += 1
            end 
        end 
        $x += 1
    end 
end 

#print "\n\nrelease.tracklist = ", release.tracklist, "\n\n"

unless release.tracklist.nil? || release.tracklist == 0
    #tracklist is not null 
   # print "release.tracklist.count = ", release.tracklist.count, "\n"
    $x = 0
    while $x < release.tracklist.count do 
        print "\nexamining track: ", release.tracklist[$x], "\n"
        #get extrartists[] tied to a track (if they exist)
        unless release.tracklist[$x]['extraartists'].nil? || release.tracklist[$x]['extraartists'] == 0
            #extra artists for a track exist
            #iterate through eahc extraartist on a track
            $z = 0
            while $z < release.tracklist[$x]['extraartists'].count do 
                tags.push(release.tracklist[$x]['extraartists'][$z]['anv'])
                tags.push(release.tracklist[$x]['extraartists'][$z]['name'])
                tags.push(release.tracklist[$x]['extraartists'][$z]['role'])
                #$trackArtistID = release.tracklist[$x]['extraartists'][$z]['id']
                #$trackArtistTags = getArtistTags($trackArtistID)
                #print "\nFFound artist tags = ", $trackArtistTags, "\n"
                #tags = combineMaps(tags, $trackArtistTags)
                $z += 1
            end 

        end
        #get title of track 
        $trackTitle = release.tracklist[$x]['title']
        tags.push($trackTitle)
        #duration of track (?)
        $x += 1
    end
end 

#companies
unless release.companies.nil? || release.companies == 0
    print "release.companies = ", release.companies, "\n"
    $z = 0
    while $z < release.companies.count do
            tags.push(release.companies[$z]['name'])
        $z += 1
    end 
end

#credits
unless release.extraartists.nil? || release.extraartists == 0
    print "release.extraartists = ", release.extraartists, "\n"
    $z = 0
    while $z < release.extraartists.count do
            tags.push(release.extraartists[$z]['name'])
        $z += 1
    end 
end

#notes

#barcode
     



print "\n tags = ", tags , "\n"
$stringMap = stringifyMap(tags.uniq, 0)
print "\nstringMap = ", $stringMap, " \n"

    
    ########################################################################################### over 
    render plain: $stringMap
  end

end
def getArtistTags(artistID)
  require 'discogs-wrapper'
  wrapper = Discogs::Wrapper.new("shop")
  print "in get artist tags function, artistID = ", artistID, " \n"
  
  artistArr = Array[]
  artist = wrapper.get_artist(artistID)
  #print "artistInfo: ", artist, " \n"
  #print "artist.members = ", artist.members,  "\n"
  
  unless artist.members.nil? || artist.members == 0

      #print "artist.members is not null, artist has multiple members\n"
      #print "artist.members.count = ", artist.members.count,  "\n"
      #iterate through each artist 
      $x = 0
      while $x < artist.members.count do
          #get id for artist
          $artistInfoID = artist.members[$x]['id']
          artistInfo = wrapper.get_artist($artistInfoID) 
          #print "artistInfo[0]: \n"

          # get name, groups, namevariations, 
          $name = artistInfo['name']
          
          artistArr.push($name)

          $namevariations = artistInfo['namevariations']
          unless $namevariations.nil? || $namevariations == 0
              #print "namevariations exist\n"
              #print $namevariations , "\n"
              artistArr = addToArray(artistArr, $namevariations)
          else 
              #print "namevariations dont exist\n"
          end 

          $groups = artistInfo['groups']
          unless $groups.nil? || $groups == 0
              #print "groups exist"
              $groupsTags = getNamesFromMap($groups)
              artistArr = addToArray(artistArr, $groupsTags)
          else 
              #print "groups dont exist"
          end

          $x += 1
      end
  
   else
      #print "artist.members is null, only analysze artist\n"
      #print "artist = ", artist,  "\n"
      $name = artist['name']
      #print "\n\n artist name = ", $name,  " -- \n\n"
      artistArr.push($name)

      $namevariations = artist['namevariations']
      unless $namevariations.nil? || $namevariations == 0
          #print "namevariations exist\n"
          #print $namevariations , "\n"
          #print "\n\n namevariations[0] = ", $namevariations[0],  " -- "
          #print "str.encode.name = ", $namevariations[0].encoding, "\n\n\n\n"
          #print "$namevariations[0].encode(Encoding::UTF_8) = ", $namevariations[0].encode(Encoding::UTF_8)
          #print "\n"
          artistArr.push($namevariations[0].encode(Encoding::UTF_8))
          #.force_encoding(Encoding::UTF_8)
          artistArr = addToArray(artistArr, $namevariations)
      else 
          #print "namevariations dont exist\n"
      end 
      
      $groups = artist['groups']
      unless $groups.nil? || $groups == 0
          #print "groups exist"
          $groupsTags = getNamesFromMap($groups)
          artistArr = addToArray(artistArr, $groupsTags)
      else 
          #print "groups dont exist"
      end
      

   end

  #print "artistArr = ", artistArr, "\n"
  artistArr = artistArr.uniq
  #print "artistArr = ", artistArr, "\n"

  return artistArr
end

def getNamesFromMap(input)
  arr = Array[]
  $z = 0
  while $z < input.count do
      $groupName = input[$z]['name']
      arr.push($groupName)
      $z += 1  
  end
  return arr 
end

def addToArray(arr, map)
  $y = 0
  while $y < map.length do
      arr.push(map[$y])
      $y += 1
  end
  return arr
end

def stringifyMap(releaseArtists, noComma)
  $tempVar = ""
  $b = 0
  while $b < releaseArtists.length do
      if noComma == 1 
          $tempVar = $tempVar + ' ' + releaseArtists[$b].to_s 
      else 
          $tempVar = $tempVar  + releaseArtists[$b].to_s + ', '
      end 
      $b += 1
  end
  return $tempVar
end

def combineMaps(tags, artistTags)
  #print "combine maps tags = ", tags, ". artistTags = ", artistTags, "\n end \n"
  $k   = 0
  while $k < artistTags.length do
      #print "pushing artistTags\n"
      tags.push(artistTags[$k])
      $k += 1
  end
  return tags
end
