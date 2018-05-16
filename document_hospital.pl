#!/usr/bin/perl 
use strict;
use warnings;
use utf8;
use DBI;
use Encode;
use Encode::HanExtra;
use Time::HiRes qw(gettimeofday);

binmode(STDOUT, ":utf8");
my ($timestamp, $start_usec) = gettimeofday;
my $city_ename = "";
my $city_ename_id = "";

#mysql -uspider_user -p123456 -Dspider_db
#print $timestamp."\n";
my $dbname = "webots_db";

my $location = "127.0.0.1";
my $port = "3306";
my $database = "DBI:mysql:$dbname:$location:$port";
my $db_user = "user1";
my $db_pass = "password1";

my $dbh = DBI->connect($database,$db_user,$db_pass);
$dbh->do("SET NAMES 'utf8mb4';");

my $cookie = "g=HDF.43.5946521e2eb43; Hm_lvt_dfa5478034171cc641b1639b2a5b717d=1497780767; Hm_lpvt_dfa5478034171cc641b1639b2a5b717d=1497780767; UM_distinctid=15cbab0c937382-0eaf25a7f7df62-495269-13c680-15cbab0c9382a4; CNZZDATA1256706712=427384444-1497775412-%7C1497775412; CNZZDATA1914877=cnzz_eid%3D1969247955-1497778740-%26ntime%3D1497778740";

my $workdir = "./www.example.com/hospital";
#my $workdir = "./new_hospital/files";
my $tmp_file_list = "$workdir/filelist.txt";

#`find $workdir -name "*.htm" > $tmp_file_list`;
`find $workdir -name "DE*.htm" > $tmp_file_list`;
#`find $workdir -name "*.htm" > $tmp_file_list`;
#`find $workdir -atime -7 -name "*.html" > $tmp_file_list`;
#find -atime -7
my $l = 0 ;
open (MYPIPE, $tmp_file_list)|| die ("Could not open file");
while (my $f = <MYPIPE>) {
  $f=&replp($f);
  #print($f);
  #$f="./www.example.com/hospital/DE4roiYGYZwX-IqNN8Z2K18e0.htm";
  &parseHtml($f);
  $l++;
  #last if($l>=1);
}

$dbh->disconnect();


sub parseHtml{ 

    my($doc) = @_;

    my $doc_content=`cat $doc `;#takes contents of the page
    $doc_content = decode(gb2312=>$doc_content);
    #printf("page: %s \n", $doc_content);
    #exit;

    my $hid = "0";
    my $yyid = "";
    my $name = "";
    my $grade = "";
    my $tel_num = "";
    my $address = "";
    my $traffic_guide = "";
    my $medical_guide = "";
    my $introduction = "";
    my $active_doctor = "";
    my $spider_url = "";
    my $loc_code = "";
    my $status = 1;
    my $views = 0;
    my $map_lat = 0;
    my $map_long = 0;
    my $map_zoom = 0;
    my $imgs_num = 0;
    my $created = $timestamp;
    my $update_date = "";
    my $map_url = "";
    my $intro_url = "";

    my $map_url_f = "";
    my $intro_url_f = "";

    my $map_content = "";
    my $intro_content = "";

    $spider_url = $url;
    $spider_url = "" if(!defined($spider_url));
    $spider_url =~ s/^\.\//http:\/\//;
    $spider_url =~ s/\n//;
    #http://new_hospital/files/DE4r0Fy0C9Luw0-qbnNyI0miZLC3b3s8R.htm
    #http://www.example.com/hospital/DE4roiYGYZwXJ165Sxq9XkxnU.htm
    $spider_url =~ s/new_hospital\/files/www.example.com\/hospital/;
   
    ($name) = $doc_content =~ m/<h1>(.+?)<\/h1>/g;
    $name = "" if(!defined($name));

    ($grade) = $doc_content =~ m/<p>\s+<a href="http:\/\/www\.example\.com\/hospital\/.+?\.htm">.+?<\/a>\((.+?)\)<\/p>/g;
    $grade = "" if(!defined($grade));

    ($tel_num) = $doc_content =~ m/<td colspan="2"><nobr>电\s+话：<\/nobr>(.+?)<\/td>/g;
    $tel_num = "" if(!defined($tel_num));
    $tel_num =~ s/'//g;

    ($address) = $doc_content =~ m/<td><nobr>地\s+址：<\/nobr>(.+?)<\/td>/g;
    $address = "" if(!defined($address));

    ($traffic_guide) = $doc_content =~ m/<td><span style="float:left;">怎 么 走：<\/span><span style="width:410px;\sfloat:left;\sclear:right;">(.+?)<\/span><\/td>/sg;

    ($traffic_guide) = $doc_content =~ m/<td><nobr>怎 么 走：<\/nobr>(.+?)<\/td>/g if(!defined($traffic_guide));
    $traffic_guide = "" if(!defined($traffic_guide));
    $traffic_guide =~ s/<br>/\n/ig;
    $traffic_guide =~ s/'/\\'/g;
    $traffic_guide =~ s/^\s+//g;
    $traffic_guide =~ s/\s+$//g;

    ($medical_guide) = $doc_content =~ m/<td style="width: 86%"><nobr>医院介绍：<\/nobr>(.+?)\s+<\/td>/g;
    $medical_guide = "" if(!defined($medical_guide));
    $medical_guide =~ s/'/\\'/g;
    $medical_guide =~ s/^\s+//g;
    $medical_guide =~ s/\s+$//g;
    #$medical_guide =~ s/...$//g;

    ($active_doctor) = $doc_content =~ m/咨询大夫：<span class="orange">(\d+)<\/span>/g;
    $active_doctor = "0" if(!defined($active_doctor));

    ($intro_url) = $doc_content =~ m/<td class="textrt" style="width: 10%;">\s+<nobr><a href="(http:\/\/info.example.com\/hospital\/.+?\/jieshao.htm)" class="blue">看详情&gt;&gt;<\/a><\/nobr>/sg;
    $intro_url = "" if(!defined($intro_url));

    ($map_url) = $doc_content =~ m/<td class="textrt">\s+<nobr><a href="(http:\/\/map.example.com\/hospital\/.+?\/map.htm)" class="blue">看地图&gt;&gt;<\/a><\/nobr>\s+<\/td>/sg;
    $map_url = "" if(!defined($map_url));
    
    $intro_url_f = $intro_url;
    $map_url_f = $map_url;
    if($intro_url_f ne "") {    
       $intro_url_f =~ s/^http:\/\//\.\//g;
       if( -e $intro_url_f){
           $intro_content=`cat $intro_url_f `;
            print "cat local_file intro\n";
       }
       else{
           $intro_content= &get_pc($intro_url, $cookie);
            print "cat remote_file intro\n";
       }
       $intro_content = decode(gb2312=>$intro_content);

       ($introduction) = $intro_content =~ m/<td colspan="3" style="font-size:14px; line-height:20px;">(.+?)<\/td>/sg;
       $introduction = "" if(!defined($introduction));
       $introduction = &removing_html_tags($introduction);

    }

    if($map_url_f ne "") {    
       $map_url_f =~ s/^http:\/\//\.\//g;
       if( -e $map_url_f){
            $map_content=`cat $map_url_f `;
            print "cat local_file map\n";
       }
       else{
           $map_content= &get_pc($map_url, $cookie);
            print "cat remote_file map\n";
       }
       $map_content = decode(gb2312=>$map_content);

       ($map_long, $map_lat) = $map_content =~ m/var point = new BMap.Point\((.+?),(.+?)\);/g;
       $map_long = "0" if(!defined($map_long));
       $map_lat = "0" if(!defined($map_lat));

       ($map_zoom) = $map_content =~ m/map.centerAndZoom(point,\s(\d+));/g;
       $map_zoom = "15" if(!defined($map_zoom));
    }
    


    my $sql1 = "";


    if(&exist_data($spider_url, $dbh)){
      #update
      $sql1 = "update t_hospital set name='$name', grade='$grade', tel_num='$tel_num', address='$address', traffic_guide='$traffic_guide', medical_guide='$medical_guide', introduction='$introduction', active_doctor='$active_doctor', map_lat='$map_lat', map_long='$map_long', map_zoom='$map_zoom', map_url='$map_url', intro_url='$intro_url' where spider_url='$spider_url';";
    }
    else{
      #insert
      $sql1 = "insert into t_hospital (hid, yyid, name, grade, tel_num, address, traffic_guide, medical_guide, introduction, active_doctor, spider_url, loc_code, status, views, map_lat, map_long, map_zoom, imgs_num, created, update_date, map_url, intro_url) values('$hid',replace(upper(uuid()),'-',''),'$name','$grade','$tel_num','$address','$traffic_guide','$medical_guide','$introduction','$active_doctor','$spider_url','$loc_code','$status','$views','$map_lat','$map_long','$map_zoom','$imgs_num',unix_timestamp(),now(),'$map_url','$intro_url');";
    }


    printf("sql: %s \n", $sql1);

    &query($sql1,$dbh);

    print "################################################################################\n";

}

sub repl{
    my($str) = @_;
    $str =~ s/ //g;
    $str =~ s/　//g;
    $str =~ s/"//g;
    $str =~ s/\n//g;
    return $str;
}

sub removing_html_tags {
    my($str) = @_;
    $str =~ s/<br \/>/##BR##/gs;
    $str =~ s/<br>/\n/sg;
    $str =~ s/<br \/>/\n/sg;
    $str =~ s/<[^>]*>//gs;
    $str =~ s/\s+/ /gs;
    $str =~ s/\\t/\n/sg;
    $str =~ s/\\r/\n/sg;
    $str =~ s/\s+$//sg;
    $str =~ s/^\s+//sg;
    $str =~ s/&lt;&lt; 收起//sg;
    $str =~ s/<\!\-\-.+?\-\->//g;
    $str =~ s/'/\\'/g;
    $str =~ s/以上总结来自//g;
    $str =~ s/好大夫在线//g;
    $str =~ s/www\.example\.com//g;
    $str =~ s/（）//g;
    #$str =~ s/\n+/\n/sg;
    $str =~ s/##BR##/\n/gs;
    return $str;
}


sub remove_a_tag {
    my $str  = shift;
    $str =~ s/<a .+?>(.+?)<\/a>/$1/ig;
    $str =~ s/^\s+//ig;
    $str =~ s/\s+$//ig;
    return $str;
}

sub replp{
  my($str) = @_;
  # agentcenter.aspx\?page\=10\&pagesize\=20\&district\=\&keyword\=\&agentname\=
  $str =~ s/\?/\\?/g;
  $str =~ s/&/\\&/g;
  $str =~ s/=/\\=/g;
  return $str;
}

sub query{
        my($sql,$dbh) = @_;
        my $sth = $dbh->prepare($sql);
        #$sth->execute() or die "error-SQL:$dbh->errstr";
        $sth->execute() or printf("error-SQL: %s ", $dbh->errstr);
}

sub get_pc{
   my($url, $cookies) = @_;
   my $CURL = "/usr/bin/curl";
   my $pc =`$CURL -s -i -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:36.0) Gecko/20100101 Firefox/36.0" --header "Host: www.example.com" --header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" --header "Accept-Language: en-US,en;q=0.5" --header "Referer: http://www.example.com/yiyuan/shanghai/list.htm" --header "Cookie: ${cookies}" --header "Cache-Control: max-age=0" "${url}"`;
  sleep 1;
  print "hold 1s.\n";
  return $pc;
}

sub exist_data{
    my($url, $dbh) = @_;
    my $id = 0;
    my $sql1 = "select hid from t_hospital where spider_url='$url';";
    my $sth = $dbh->prepare($sql1);
    $sth->execute() or die "error-SQL:$dbh->errstr";
    if (my $ref = $sth->fetchrow_hashref()) {
       $id = $ref->{hid};
    }
    return $id;
}

=head
####################################################################
Variables List
####################################################################
my $hid = "";
my $yyid = "";
my $name = "";
my $grade = "";
my $tel_num = "";
my $address = "";
my $traffic_guide = "";
my $medical_guide = "";
my $introduction = "";
my $active_doctor = "";
my $spider_url = "";
my $loc_code = "";
my $status = "";
my $views = "";
my $map_lat = "";
my $map_long = "";
my $map_zoom = "";
my $imgs_num = "";
my $created = "";
my $update_date = "";
my $map_url = "";
my $intro_url = "";
####################################################################
Insert Statement
####################################################################
insert into t_hospital (hid, yyid, name, grade, tel_num, address, traffic_guide, medical_guide, introduction, active_doctor, spider_url, loc_code, status, views, map_lat, map_long, map_zoom, imgs_num, created, update_date, map_url, intro_url) values('$hid','$yyid','$name','$grade','$tel_num','$address','$traffic_guide','$medical_guide','$introduction','$active_doctor','$spider_url','$loc_code','$status','$views','$map_lat','$map_long','$map_zoom','$imgs_num','$created','$update_date','$map_url','$intro_url');
####################################################################
Update Statement
####################################################################
update t_hospital set hid='$hid', yyid='$yyid', name='$name', grade='$grade', tel_num='$tel_num', address='$address', traffic_guide='$traffic_guide', medical_guide='$medical_guide', introduction='$introduction', active_doctor='$active_doctor', spider_url='$spider_url', loc_code='$loc_code', status='$status', views='$views', map_lat='$map_lat', map_long='$map_long', map_zoom='$map_zoom', imgs_num='$imgs_num', created='$created', update_date='$update_date', map_url='$map_url', intro_url='$intro_url' where hid=?;
####################################################################
Select Statement
####################################################################
select hid, yyid, name, grade, tel_num, address, traffic_guide, medical_guide, introduction, active_doctor, spider_url, loc_code, status, views, map_lat, map_long, map_zoom, imgs_num, created, update_date, map_url, intro_url from t_hospital where hid=?;
=cut

=head
if ( -e $img_file ) {
}
=cut
