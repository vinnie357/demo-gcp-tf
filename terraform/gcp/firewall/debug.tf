resource "local_file" "onboard_file" {
  content     = "${data.template_file.vm_onboard.rendered}"
  filename    = "${path.module}/onboard-debug-bash.sh"
}