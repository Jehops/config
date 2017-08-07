$pdf_mode = 1;
$pdf_previewer = "pv %O %S";
$pdf_update_method = 4;
$pdf_update_command = "pv %O %S";
#$preview_continuous_mode = 1;
#$preview_mode = 1;

add_cus_dep('glo', 'gls', 0, 'makeglo2gls');
sub makeglo2gls {
    system("makeindex -s '$_[0]'.ist -t '$_[0]'.glg -o '$_[0]'.gls '$_[0]'.glo");
}
