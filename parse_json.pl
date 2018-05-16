#!/usr/bin/perl 
use strict;
use warnings;
use utf8;
use JSON;
use DBI;
use Encode;
use Encode::HanExtra;
use Time::HiRes qw(gettimeofday);
use Data::Dumper;
use URI::Escape;
#use Error qw(:try);
use Try::Tiny;


binmode(STDOUT, ":utf8");
my ($timestamp, $start_usec) = gettimeofday;

# Initialize some variables set by options.
# /home/tonycai/spider-tools/example_hotels/hotel_list/10819/list-1.html
#  echo  "/home/tonycai/spider-tools/example_hotels/hotel_list/10819/list-1.html" | ./parse_json.pl 


my $fh;
while (defined($fh = <>)){
  print "string=$fh \n";
  my $pois_data = `cat $fh | grep "BigPipe.onPageletArrive"`;
  $pois_data = decode(gb2312=>$pois_data); 
  $pois_data =~ s/\\\//\//g;
  $pois_data =~ s/\\"/"/g;
  $pois_data =~ s/\\n/<br>/g;
  $pois_data = &scon($pois_data);
  print "$pois_data \n";
  exit;
  try{
    my $j = from_json($pois_data);
  
    #print $j->{html} ."\n";
    #print $j->{msg}->{count} ."\n";
    my $html = $j->{html} ;
    &parse_html($html);
 
  }catch{
    warn "caught error: ";
  }
}

sub scon
{
 my $str = shift;
 $str =~ s/\\u([[:xdigit:]]{1,4})/chr(eval("0x$1"))/egis;
 return $str;
}

sub parse_html
{
 my $hd = shift;
 my @pios = $hd =~ m/(<div class="hotel-item clearfix h-item" data-name=".+?" data-lat="\d+\.\d+" data-lng="\d+\.\d+" data-id="\d+">)/g;
 my $n = 0;
 for(@pios){
   my $poi = $_;
   my ($name, $lat, $lng, $hid) = $poi =~ m/<div class="hotel-item clearfix h-item" data-name="(.+?)" data-lat="(\d+\.\d+)" data-lng="(\d+\.\d+)" data-id="(\d+)">/g;
   print "name: $name, lat: $lat, lng: $lng, hid: $hid, url: http://www.example.cn/hotel/${hid}.html\n";
   $n++;
 }
 print "Total: $n \n";

}

exit;
#=========

=head

# <div class="hotel-item clearfix h-item" data-name="新驿旅店台北车站二馆 (CityInn Hotel Taipei Station Branch II)" data-lat="25.050146723295" data-lng="121.51651382446" data-id="92467">

my @pios = $pois_data =~ m/({"poiid":.+?"poiurl":.+?})/g;

for(@pios){
   my $poi = $_;

   my $poiid = $j->{poiid};
   my $title = $j->{title};
   my $address = $j->{address};
   my $lon = $j->{lon};
   my $lat = $j->{lat};
   my $category = $j->{category};
   my $city = $j->{city};
   my $province = $j->{province};
   my $country = $j->{country};
   my $url = $j->{url};
   my $phone = $j->{phone};
   my $postcode = $j->{postcode};
   my $weibo_id = $j->{weibo_id};
   my $icon = $j->{icon};
   my $categorys = $j->{categorys};
   my $category_name = $j->{category_name};
   my $map = $j->{map};
   my $poi_pic = $j->{poi_pic};
}
=cut
