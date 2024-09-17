# Switch into Nix Shell Action

This GitHub Action switches into a Nix shell and exports the environment variables to subsequent steps.

## Inputs

### `nix_args`

**Optional** Additional arguments to pass to `nix print-dev-env`.

## Usage

```yaml
steps:
  - uses: actions/checkout@v4

  - name: Switch into Nix Shell
    uses: lukas-mertens/switch-into-nix-shell@v1

  - name: Use nix env
    run: |
      which vim
```

Or pass args to nix `print-dev-env`:
```yaml
steps:
  - uses: actions/checkout@v4

  - name: Switch into Nix Shell
    uses: lukas-mertens/switch-into-nix-shell@v1
    with:
      nix_args: '--impure'

  - name: Use nix env
    run: |
      which vim
```

