# Author::    Song An BUI (mailto:songan.bui@gmail.com)
# Copyright:: Copyright (c) 2015 Song An BUI
# License::   MIT

# == Define msoffice::settings::excel
#
# This definition configures settings for MS Office Excel
#
# === Parameters
#
# [*version*]
# The version of office to configure
#
# [*arch*]
# The architecture of MS Office Suite
# Values: x86;x64
#
# [*VBAWarnings*]
# Set security level for VBA Warning messages
# Values: 1;2;3;4 
# Please refer to: https://technet.microsoft.com/en-us/library/cc178946(v=office.12).aspx
#
# [*AccessVBOM*]
# Enable or disable access to VB Object Model
# Values: 0;1
#
define msoffice::settings::excel (
  $version,
  $arch = 'x86',
  $vbaWarnings = '1',
  $accessVBOM = '1'
){
  include msoffice::params
  $office_num = $msoffice::params::office_versions[$version]['version']
  
  if ($::architecture=='x64' and $arch=='x86') {
    $office_reg_key = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Office'
    $office_reg_hkcu_key = 'HKCU:\SOFTWARE\Wow6432Node\Microsoft\Office'
  }
  else {
    $office_reg_key = 'HKLM:\SOFTWARE\Microsoft\Office'
    $office_reg_hkcu_key = 'HKCU:\SOFTWARE\Microsoft\Office'
  }

  registry::value { 'VBAWarnings':
    key  => "${office_reg_key}\\${office_num}.0\\Excel\\Security",
    type => 'dword',
    data => $vbaWarnings,
  }
  # VBAWarnings does not seem to work system-wide. Must use HKCU.
  #$excel_vbawarnings_key = "${office_reg_hkcu_key}\\${office_num}.0\\Excel\\Security"
  #$excel_vbawarnings_name = 'VBAWarnings'
  #$excel_vbawarnings_value = $vbaWarnings
  #exec { 'Excel VBAWarnings HKCU':
  #  path     => $::path,
  #  provider => powershell,
  #  command  => template('msoffice/set_excel_vbawarnings.ps1.erb'),
  #  unless   => template('msoffice/check_excel_vbawarnings.ps1.erb'),
  #}

  registry::value { 'AccessVBOM':
    key  => "${office_reg_key}\\${office_num}.0\\Excel\\Security",
    type => 'dword',
    data => $accessVBOM,
  }

}