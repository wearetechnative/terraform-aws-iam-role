locals {
  compact_role_path   = compact(split("/", var.role_path))
  validated_role_path = length(local.compact_role_path) > 0 ? format("/%s/", join("/", local.compact_role_path)) : "/"
}
