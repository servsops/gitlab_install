# gitlab_install-cookbook

## TODO

* choose whether install postfix or use gitlab smtp function

* use chef with ruby2.1.1


## Usage

### Edit attributes in solo.json

```
{
  "run_list": [
    "gitlab_install"
  ]
}
```

### For chef-solo

```
#install berkshelf: support ubuntu 12.04, 14.04

bash install_berkshelf.sh

#use berk create cookbooks directory, run with chef-solo
#edit solo.json
bash run_solo_script.sh

#re-run
chef-solo -c solo.rb -j solo.json
```

## Notes

### ruby2.1.1 compile bug

* because readline library update, one function ruby use to compile is delete from source code. So, one patch applied, maybe I will remove it later when ruby upgrade. [201404]
