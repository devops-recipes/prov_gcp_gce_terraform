# Setup our aws provider
provider "google" {
  credentials = "${var.json_key}"
  project = "${var.google_project_id}"
  region = "${var.region}"
}

# instances
resource "google_compute_instance" "gce_ins" {
  name = "test-${count.index+1}"
  count = "${var.machine_count}"
  machine_type = "${var.machine_type}"
  zone = "${var.zone}"

  tags = [
    "${var.tags}"]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP leaving this blank will give a new public ip
    }
  }

  metadata {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"
}

output "gce_ins_0_ip" {
  value = "${google_compute_instance.gce_ins.0.network_interface.0.access_config.0.assigned_nat_ip}"
}
