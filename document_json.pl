#!/usr/bin/perl 
use strict;
use warnings;
use utf8;
use DBI;
use Encode;
use Encode::HanExtra;
use Time::HiRes qw(gettimeofday);
use JSON qw/encode_json decode_json/;  
use Data::Dumper;  
use URI::Escape;

binmode(STDOUT, ":utf8");
my ($timestamp, $start_usec) = gettimeofday;



###

my $json_str = '{"id":"bp_top","content":"<style>\n.topbar_box3 .topbar .topbar_left .logo {\n    background-image: url(http:\/\/i1.hdfimg.com\/www\/images\/toplogo_small.png);\n    background-size: 156px 44px;\n    display: inline-block;\n    width: 156px;\n    height: 44px;\n    float: left;\n    background-position: 0 0;\n    margin-left: 20px;\n    margin-right: 12px;\n    margin-top: -4px;\n}\n<\/style>\n<div class=\"hdf_menu\">\n    <div>\n    <p style=\"clear:both\"><\/p>\n    <\/div>\n  <div class=\"hdf_menu_subTitle\" style=\"border-left:1px;margin-left:-10px;line-height:20px;margin-right: 20px;margin-top: 10px;\" style=\"border:none;\" ><\/div>\n  <ul class=\"menu_list\" style=\"float:left;\">\n    <li><a href=\"http:\/\/www.haodf.com\" rel=\"nofollow\">\u9996\u9875<\/a><\/li>\n    <li><strong>\u627e\u5927\u592b\uff1a<\/strong>\n\t    <a href=\"http:\/\/www.haodf.com\/jibing\/list.htm\" class=\"\">\u6309\u75be\u75c5<\/a>\n        <a href=\"http:\/\/www.haodf.com\/yiyuan\/all\/list.htm\" class=\"\">\u6309\u533b\u9662<\/a>\n\t    <a href=\"http:\/\/www.haodf.com\/keshi\/list.htm\"  class=\"\">\u6309\u4e13\u79d1<\/a>\n    <\/li>\n    <li><strong>\u54a8\u8be2\u4e13\u5bb6\uff1a<\/strong>\n    \t<a href=\"http:\/\/zixun.haodf.com\/\">\u7f51\u4e0a\u54a8\u8be2<\/a>\n    \t<a href=\"http:\/\/400.haodf.com\/\">\u7535\u8bdd\u54a8\u8be2<\/a>\n        <a href=\"\/\/www.haodf.com\/familydoctor\/showdoctorlist?from=wwwheadnav\">\u5bb6\u5ead\u533b\u751f<\/a>\n    <\/li>\n    <li>\n    \t<a href=\"http:\/\/jiahao.haodf.com\/\">\u9884\u7ea6\u8f6c\u8bca<\/a>\n    <\/li>\n    <li>\n    \t<a href=\"http:\/\/www.haodf.com\/haiwai\" rel=\"nofollow\">\u6d77\u5916\u5c31\u8bca<\/a>\n    <\/li>\n    <li style=\"overflow: visible;\">\n    \t<a href=\"http:\/\/www.haodf.com\/paper\/doctorhonor2016\" rel=\"nofollow\">\u54c1\u724c\u6c47<img style=\"position: absolute; top: -10px; right: -20px;\" src=\"http:\/\/i1.hdfimg.com\/www\/images\/afterStarNewLogo.png\" alt=\"\"\/><\/a>\n    <\/li>\n  <\/ul>\n<\/div>\n<div class=\"hdf_menu_sec\">\n<\/div>\n<div style=\"clear: both; height: 30px; line-height: 30px; font-size: 14px; width: 960px; margin: -10px auto -2px; color: #176acc;text-align:left\">\n\u597d\u5927\u592b\u5728\u7ebf\u662f\u533b\u60a3\u6c9f\u901a\u5e73\u53f0\uff0c\u533b\u751f\u57fa\u4e8e\u60a3\u8005\u81ea\u8ff0\u75c5\u60c5\u6240\u53d1\u8868\u7684\u8a00\u8bba\u4ec5\u4f9b\u53c2\u8003\uff0c\u4e0d\u80fd\u4f5c\u4e3a\u8bca\u65ad\u548c\u6cbb\u7597\u7684\u76f4\u63a5\u4f9d\u636e\u3002\n<\/div>\n<div class=\"container\">\n  <div class=\"mian\">\n<div id=\"doctor_header\">\n    <div class=\"lt\" style=\"width:auto\">\n        <div class=\"lt_name\" style=\"padding-left:10px\">\n            <a href=\"http:\/\/www.haodf.com\/doctor\/DE4r0BCkuHzdeCUNhI2bpNCqpa7rv.htm\">\n            <h1>\n\t    <span style=\"float:left\">\u4efb\u732e\u56fd<\/span>\n\t    <span id=\"ajaxcollecdoctor\" style=\"float:left;margin-top:12px;\"> <\/span>\n            <\/h1>\n            <\/a>\n        <\/div>\n\n    <\/div>\n      <div class=\"navbar\" style=\"width:auto; float:right;\">\n        <a class=\"white\" href=\"http:\/\/www.haodf.com\/doctor\/DE4r0BCkuHzdeCUNhI2bpNCqpa7rv.htm\" target=\"_blank\">\n        <div class=\"nav\">\n          <h2 style=\"text-decoration:underline\">\u5927\u592b\u9996\u9875<\/h2>\n        <\/div>\n       <div class=\"navrt\"> <\/div>\n        <\/a>\n                <a class=\"orange\"  href=\"http:\/\/www.haodf.com\/jingyan\/all-renxianguo.htm\" target=\"_blank\" >\n        <div class=\"nav2\">\n          <h2 style=\"text-decoration:underline\">\u60a3\u8005\u6295\u7968<\/h2>\n        <\/div>\n        <div class=\"navrt2\"> <\/div>\n        <\/a>\n        \n                <a class=\"orange\"  href=\"http:\/\/www.haodf.com\/doctor\/284202-all-servicestar.htm\" target=\"_blank\" >\n            <div class=\"nav2\">\n              <h2 style=\"text-decoration:underline\">\u4e34\u5e8a\u7ecf\u9a8c<\/h2>\n            <\/div>\n            <div class=\"navrt2\"> <\/div>\n        <\/a>\n        \n                <a class=\"orange\" href=\"http:\/\/renxianguo.haodf.com\/\" target=\"_blank\">\n        <div class=\"nav2\">\n          <h2 style=\"text-decoration:underline\">\u4e2a\u4eba\u7f51\u7ad9<\/h2>\n        <\/div>\n        <div class=\"navrt2\"> <\/div>\n        <\/a>\n                        <a class=\"orange\" href=\"http:\/\/renxianguo.haodf.com\/lanmu\" target=\"_blank\">\n        <div class=\"nav2\">\n          <h2 style=\"text-decoration:underline\">\u6587\u7ae0\u5217\u8868<\/h2>\n        <\/div>\n        <div class=\"navrt2\"> <\/div>\n        <\/a>\n                        <a class=\"orange\" href=\"http:\/\/renxianguo.haodf.com\/zixun\/list.htm\" target=\"_blank\">\n        <div class=\"nav2\">\n          <h2 style=\"text-decoration:underline\">\u60a3\u8005\u670d\u52a1\u533a<\/h2>\n        <\/div>\n        <div class=\"navrt2\"> <\/div>\n        <\/a>\n        \n        <div class=\"cls\"><\/div>\n      <\/div>\n      <div class=\"cls\"><\/div>\n<\/div>\n<div class=\"navbar\">\n    <\/div>\n    <div class=\"luj\" style=\"float:left;\">\n\t\t&nbsp;&nbsp;\u5f53\u524d\u4f4d\u7f6e\uff1a<a href=\"http:\/\/www.haodf.com\" target=\"_blank\" rel=\"nofollow\">\u597d\u5927\u592b\u5728\u7ebf-\u667a\u6167\u4e92\u8054\u7f51\u533b\u9662<\/a> &gt;\n                <a href=\"http:\/\/www.haodf.com\/yiyuan\/all\/list.htm\" target=\"_blank\">\u533b\u9662\u5217\u8868<\/a> &gt;\n\t\t\t\t<a href=\"http:\/\/jiangsu.haodf.com\" target=\"_blank\">\u6c5f\u82cf<\/a> &gt;\n\t\t\t\t<a href=\"\/hospital\/DE4roiYGYZwXJ165Sxq9XkxnU.htm\" target=\"_blank\">\u5357\u4eac\u603b\u533b\u9662<\/a> &gt;\n\t\t\t\t<a href=\"\/faculty\/DE4r08xQdKSLeSmxrtdX6gWDmEzh.htm\" target=\"_blank\">\u513f\u7ae5\u80be\u810f\u8bca\u7597\u4e2d\u5fc3<\/a> &gt;\n              <a href=\"http:\/\/www.haodf.com\/doctor\/DE4r0BCkuHzdeCUNhI2bpNCqpa7rv.htm\">\u4efb\u732e\u56fd<\/a> &gt; \u4fe1\u606f\u4e2d\u5fc3\u9875\n\t<\/div>\n\t<div class=\"cls\"><\/div>\n  <\/div>\n<\/div>\n","cssList":[],"jsList":[]}';

#my $decode = decode_json($json_str);  
my $decode = JSON->new->utf8->decode($json_str)


print Dumper($decode);
