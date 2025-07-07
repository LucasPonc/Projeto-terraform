# Projeto Terraform
```
Este repositório contém um projeto básico utilizando Terraform para provisionamento de infraestrutura. Ideal para testes e aprendizado de automação de recursos 
```
# Pré-requisitos
```
uma máquina Linux com KVM instalado e configurado

terraform instalado (versão 1.0 ou superior)

libvirt e virsh configurados e funcionando (ex: libvirt daemon ativo)

Plugin Terraform para libvirt instalado (terraform-provider-libvirt)

Permissões para gerenciar VMs via libvirt (usuário no grupo libvirt ou sudo)
```
# Execução
```
Siga os passos abaixo para executar o projeto:

1. Clone o repositório

git clone https://github.com/LucasPonc/Projeto-terraform.git

cd Projeto-terraform

2. Inicialize o Terraform

terraform init

Esse comando prepara o ambiente e baixa os plugins do provedor.

3. Aplique a infraestrutura

terraform apply

Confirme a execução quando solicitado (digite yes).

4. (Opcional) Destrua a infraestrutura

terraform destroy

Esse comando desfaz todas as alterações e remove os recursos criados.
```
# Estrutura Básica
```
Projeto-terraform/
├── main.tf           # Definições principais dos recursos
├── provider.tf       # Configuração do provedor
├── variables.tf      # Variáveis utilizadas
├── outputs.tf        # Informações de saída após criação
└── terraform.tfvars  # Valores atribuídos às variáveis****
