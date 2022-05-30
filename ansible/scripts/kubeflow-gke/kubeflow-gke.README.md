Understanding the deployment process

This section gives you more details about the kubectl, kustomize, config connector configuration and deployment process, so that you can customize your Kubeflow deployment if necessary.
Application layout

Your Kubeflow application directory gcp-blueprints/kubeflow contains the following files and directories:

    Makefile is a file that defines rules to automate deployment process. You can refer to GNU make documentation for more introduction. The Makefile we provide is designed to be user maintainable. You are encouraged to read, edit and maintain it to suit your own deployment customization needs.

    apps, common, contrib are a series of independent components directory containing kustomize packages for deploying Kubeflow components. The structure is to align with upstream kubeflow/manifests.

        kubeflow/gcp-blueprints repository only stores kustomization.yaml and patches for Google Cloud specific resources.

        ./pull_upstream.sh will pull kubeflow/manifests and store manifests in upstream folder of each component in this guide. kubeflow/gcp-blueprints repository doesn’t store the copy of upstream manifests.

    build is a directory that will contain the hydrated manifests outputted by the make rules, each component will have its own build directory. You can customize the build path when calling make command.

Source Control

It is recommended that you check in your entire local repository into source control.

Checking in build is recommended so you can easily see differences by git diff in manifests before applying them.
Google Cloud service accounts

The kfctl deployment process creates three service accounts in your Google Cloud project. These service accounts follow the principle of least privilege. The service accounts are:

    ${KF_NAME}-admin is used for some admin tasks like configuring the load balancers. The principle is that this account is needed to deploy Kubeflow but not needed to actually run jobs.
    ${KF_NAME}-user is intended to be used by training jobs and models to access Google Cloud resources (Cloud Storage, BigQuery, etc.). This account has a much smaller set of privileges compared to admin.
    ${KF_NAME}-vm is used only for the virtual machine (VM) service account. This account has the minimal permissions needed to send metrics and logs to Stackdriver.

Upgrade Kubeflow

Refer to Upgrading Kubeflow cluster.
Next steps

    Run a full ML workflow on Kubeflow, using the end-to-end MNIST tutorial or the GitHub issue summarization Pipelines example.
    Learn how to delete your Kubeflow deployment using the CLI.
    To add users to Kubeflow, go to a dedicated section in Customizing Kubeflow on GKE.
    To taylor your Kubeflow deployment on GKE, go to Customizing Kubeflow on GKE.
    For troubleshooting Kubeflow deployments on GKE, go to the Troubleshooting deployments guide.
