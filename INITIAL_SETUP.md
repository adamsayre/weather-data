# Steps to set up from a cold install

## Initial setup

Install python3

Ensure you have the following:
- python3.11 `which python3`
- pip3 `which pip3`

If pip is missing run `python3 -m ensurepip`

### Venv

Set up the `weather-env` venv:

```bash
cd top/of/weather/data/repo
python3 -m venv weather-env
source ./weather-env/bin/activate
pip3 install -r requirements.txt
```

* 1st command changes directory to the top dir of the repo
* 2nd makes the venv called weather-env
* third activates the venv
* fourth installs the requirements listed at requirements.txt

### Linters

Set sqlfluff up in vscode if you're using it - if you use it on cli you're good, its already installed with the above.

```bash
which sqlfluff
```

In vscode - open extensions and install `sqlfluff` by "dorzey". Open the settings, and under the "sqlfluff executable" setting, paste the output of `which sqlfluff`

### Databricks PAT

You'll need an access token before you do DBT so it can run commands/queries on databricks.

To make a PAT on databricks:
1. click your profile in top right
1. choose "Developer" under User at left
1. under "Access Tokens" click the "manage" button
1. create a new one, name it "local DBT {name for your computer}"
1. set it to 90 day expiration
1. copy the token 

### DBT

cd into the `weather_data` directory to run dbt commands!

```bash
cd weather_data
```

Now you can set up dbt!

```bash
dbt init
```

Follow the commands, here's my profile file with the info it asks (i've blanked the token).

```yaml
weather_data:
  outputs:
    dev:
      catalog: workspace
      host: https://dbc-0f570a3d-e4ed.cloud.databricks.com/
      http_path: /sql/1.0/warehouses/da6ef89d4475e56c
      schema: gold
      threads: 4 # this should only be what your computer handle, choose 1 if you're not sure!
      token: {your token will be here} # no curly braces, just the text, no quotes either
      type: databricks
  target: dev
```

Paste into the setup interactive when asked or just go to `/Users/{yourname}/.dbt/profiles.yml` and edit in place

Run debug command to confirm it's all workin!

```bash
dbt debug
```
