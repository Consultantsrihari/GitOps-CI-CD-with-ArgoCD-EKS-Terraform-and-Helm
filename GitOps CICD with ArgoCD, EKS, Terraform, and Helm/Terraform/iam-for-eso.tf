# This defines the permission policy in JSON format.
# It only allows reading secrets that start with the prefix "guestbook/".
data "aws_iam_policy_document" "secret_reader_policy" {
    statement {
        actions   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
        resources = ["arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:guestbook/*"]
        effect    = "Allow"
    }
}

# This creates the actual IAM Policy resource from the JSON above.
resource "aws_iam_policy" "secret_reader_policy" {
    name        = "${var.cluster_name}-secret-reader-policy"
    description = "Allows reading specific secrets from Secrets Manager"
    policy      = data.aws_iam_policy_document.secret_reader_policy.json
}

# This is a helper to get the current AWS Account ID.
data "aws_caller_identity" "current" {}

# This is the main resource. It creates the IAM Role.
module "iam_assumable_role_for_sa" {
    source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
    version = "5.30.0"

    create_role                   = true
    role_name                     = "${var.cluster_name}-guestbook-sa-role"
    # This links the role to our cluster's OIDC provider (which the EKS module created for us).
    provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
    # Attaches the read-only policy we created above.
    role_policy_arns              = [aws_iam_policy.secret_reader_policy.arn]
    # THIS IS THE MAGIC LINK: It specifies that only a Service Account named 'guestbook-sa'
    # in the 'guestbook' namespace can assume this role.
    oidc_fully_qualified_subjects = ["system:serviceaccount:guestbook:guestbook-sa"]
}