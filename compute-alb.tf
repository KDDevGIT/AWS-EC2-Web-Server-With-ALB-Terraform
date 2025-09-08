locals {
    user_data_b64 = base64encode(file("${path.module}/userdata.sh}"))
}

