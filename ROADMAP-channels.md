# Roadmap: canais `latest` / `next` / `testing`

Anotação de planejamento (não é doc de usuário final). Contexto completo na conversa de
2026-09-26/27 com Claude Code.

## Modelo

Pensar em **canais**, não em branches — a branch/recipe por trás é só o mecanismo, descartável e
recriável; o canal é a promessa estável para quem rebaseia.

| Canal | Promessa | Vida | Mecanismo |
|---|---|---|---|
| `latest` | Versão vigente, testada | Permanente | `main`, sempre |
| `next` | Próxima versão do Fedora, em ensaio | Recorrente por ciclo do Fedora (~6 meses), recriado a cada versão | Recipe próprio na `main` (`cloche-next.yml`), não branch — evita merge bidirecional |
| `testing` / `pr-N` | O que estou testando agora | Efêmera, por tarefa | Branch/PR qualquer, tag automática, descartada no merge |

Promoção é **por item** (cherry-pick de commit específico), nunca merge de branch inteira — é assim
que Arch (`testing`→`stable`), Debian/Ubuntu (SRU) e o próprio Fedora (branches por versão, sem merge
entre elas) fazem. Evita arrastar mudanças ainda incompletas.

## Cloche 45 = "Ascent"

## Bloqueio atual (checado em 2026-09-27)

- `quay.io/fedora-ostree-desktops/base-atomic` **já tem tags `45.*`** (Fedora compôs o beta).
- `ghcr.io/ublue-os/base-main` (o que o `cloche` usa hoje) **ainda só tem `43`, `44`, `gts`, `latest`**
  — sem `45`.
- `base-main` é construído a partir de `quay.io/fedora-ostree-desktops/silverblue:44` (não
  `base-atomic`) + akmods + suporte NVIDIA opcional + scripts próprios do ublue
  (`install.sh`/`initramfs.sh`/`post-install.sh`) + `bootc container lint`. Ou seja, `base-atomic`
  **não é equivalente** a `base-main` — falta a camada ublue inteira (kernel modules pré-compilados,
  convenções, possíveis pacotes que o `cloche.yml` assume implicitamente).
- `ublue-os/main` não tem branch nem PR preparando o 45 ainda (só uma `beta44` antiga, confirmando
  que eles próprios usam esse padrão de branch-canal por versão beta).

**Decisão:** não construir a `next` sobre `base-atomic` agora — seria testar uma combinação parcial
(Fedora 45 sem a camada ublue) e não indicaria nada confiável sobre o `base-main:45` real.

## Gatilho para retomar

Checar periodicamente (ou quando lembrar):
- `ghcr.io/ublue-os/base-main` ganhou tag `45`? (`skopeo list-tags docker://ghcr.io/ublue-os/base-main`)
- ou `ublue-os/main` abriu branch/PR de bump para Fedora 45?

## Passos, quando desbloqueado

1. Criar `recipes/cloche-next.yml` no `cloche`:
   - `base-image: ghcr.io/ublue-os/base-main`, `image-version: 45`
   - `PRETTY_NAME: "Cloche 45 (Ascent)"`
   - Módulos: extrair lista compartilhada para um arquivo comum incluído via `from-file` pelos dois
     recipes (`cloche.yml` e `cloche-next.yml`), para não duplicar manutenção.
2. Adicionar `cloche-next.yml` na matrix dos jobs `bluebuild` e `scan` em `.github/workflows/build.yml`.
   Como o BlueBuild nomeia a imagem pelo `name:` do recipe, sai como repo GHCR próprio
   (`ghcr.io/cloche-project/cloche-next`) com sua própria `:latest` — não colide com a tag `latest`
   do `cloche` normal.
3. Validar o primeiro build manualmente antes de qualquer coisa depender dele.
4. Repetir o mesmo padrão em `cloche-standard` (`standard-*-next.yml`, `base-image:
   ghcr.io/cloche-project/cloche-next`), só depois do `cloche-next` estar validado.
5. Corrigir o `tags: latest, main` fixo no `build.yml` (linha ~58) — hoje não atrapalha a `next`
   (repo GHCR separado), mas vai atrapalhar a primeira `testing` real: qualquer branch/PR nesse
   estado publicaria por cima da tag `latest`. Trocar para deixar o BlueBuild nomear pela branch, e
   ajustar os filtros de `push`/`pull_request` (`branches: [main, next]`, tirar o `beta` órfão que
   ainda está lá desde a tentativa anterior).
6. Promoção do F45 (quando decidido estável): trocar `image-version`/`PRETTY_NAME`/`base-image` no
   `cloche.yml` de verdade, apagar `cloche-next.yml`. Repetir a promoção de item (não merge de
   branch) para qualquer coisa que só existia no canal `next`.

## Fora de escopo por agora

- `cloche-pro` / `cloche-pro-workstation` (CentOS Stream, rolling — sem "próxima versão" a ensaiar).
- `cloche-xe` (segue o calendário do Universal Blue/Bazzite, não o do Fedora diretamente).
- `rpm-repo`: sem canal de teste dedicado; RPM se testa manualmente via `testing`/PR do consumidor.
- Bot de merge automático `main`→`next`: não vale o custo de manutenção para uma pessoa só; feito
  manual quando for atualizar a `next`.
