module sigs.k8s.io/kustomize/plugin/builtin/imagetagtransformer

go 1.14

require (
	sigs.k8s.io/kustomize/api v0.5.0
	sigs.k8s.io/yaml v1.2.0
)

replace sigs.k8s.io/kustomize/api v0.5.0 => ../../../api
