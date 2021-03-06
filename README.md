[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg?style=plastic)](https://lbesson.mit-license.org/)
![GitHub commit activity](https://img.shields.io/github/commit-activity/m/clockfix/audio_effects_FPGA?style=plastic)
![GitHub last commit](https://img.shields.io/github/last-commit/clockfix/audio_effects_FPGA?style=plastic)
![GitHub contributors](https://img.shields.io/github/contributors/clockfix/audio_effects_FPGA?style=plastic)
# Audio effects on FPGA

Audio effect synthesizer on FPGA

Audio hardware

![PMOD_I2S2](https://euborw.bl.files.1drv.com/y4mwscr7u3Q0WJKuOjfrLSFswmMhJFcQz_qvUDQmWPsWANUPPx3s-RrdHahplWN4MPxWtFJAZCzZokzS9oG3hJRHTa8-hztUF-5ix6DoEZ3FbW79HuWuWykaC6-vPQCz_jN-qtZzENmEM_CL7x6Fu-V3fVBwSbUUZ1B4FpyTJbHc2y09jmmIoznP9JKdHkloQC22fRvzkGEwn-uEL7m5GIYtg/pmod_i2s2.jpg) ![PMOD_I2S2_package](https://jhuenw.bl.files.1drv.com/y4mh-JRwzfInJGsB7npvB02QFP4E8O0fYseJrh7mCKZPhDtrRKAkyIU4vrSgIPZ57SPrRugP-CoS5pu-_W9fq1E2gV9SOYeyPc2In_a5uqQzCtwXbUYRvOQnHEt-zomphOLXn2Uw7RpaKbKLNvgQfF-pJNqbiX5LAaW5zODYNF66IESQ3uHqDSOCEtjt620oITZFzO71EyDkpSPB3bvZ61J6Q/pmod_i2s2_package.png)

i2s timing diagram from PulseView
![i2s timing diagram](https://jxuqnw.ch.files.1drv.com/y4m-dZeGZ7098LnxNfhcXYLc_boX5bUNKolrZoOikvJ15bhmx83OEfjXsL0DOx4bJQwo9Nj8JhPdbH3-p2_NsPtkQLQMjqqvHQD1aoTLU4iCGlzmuDkeRaJ4hOWEjlSxfPTpLuJmFxd3Co8m7PUNAHw-lSomMgNqrO4Sw_8E4K-vfiS2ijUOfIdlW4VUDLv0Dku1zcMel3jQGcMSIH0GiQyRA/i2s-loopback.png?psid=1)

Top module
![Top module_sh](https://sqtelw.ch.files.1drv.com/y4mxBDwlvgiYYZpsOjIUey0ctL7StvY-ymQdAxhs5_GToLB8sdDlbh9qd3IBUiguuYbraYpqDg2BVUclm8n7UIdIcLIz0468d-e_VIgsLgY13Z839dn2THBu_PKbq3MLZOmwJNjH0Jz8qq0SNr2UjZkyJjSmdmESf44Qv5DrNMVEhvl6jLvw0FxN23E7dme2MloArlCMLJ9PznU9qzNhD2RLw/top-audio-effects.png?psid=1)

Edited effect control module - now it has input and output FIFO memory
![efect_controler](https://pgow6w.ch.files.1drv.com/y4mG--fP9LI78p-SQYukYLlqkbHOkXCmfO6cLVgHcND0Z5G7J7-75dlO2Yva33k0KdAt6DBWdQDT_TH_6L_pjNxXHaczVTaUecui2-qpfOD4EW0GP8TtewGPuC7wsESNzd0Nsl4QSDfLzFV8uZZWeq2_VTadlnqPmQRSfs9115fiK8yLqdl17fzZZ4Q0LuhbOlbFV0aOpUqC0zBi6_FxK_xtw/efect_controler.png?psid=1)

IO module
![io_module](https://b6w9pw.ch.files.1drv.com/y4mgPXnMZOMUJWVUBhbHNP217wE84t29_bt9uDZ7lbozZTPFiq3Ncan_uSvk7YjRzmkIPma5t_dcwxAvLgd8ZV5n1GBIzJ5cCEiS1gCR0y7y4x5brYBBRXjJh5VXI0ITpQRCvlggTSzNZE4b7Ux8hvzoxa586RGty8d-a1eblClQE3GD4QAiPMV0CrT-ROt7axdN_ArKMn0HKHCYomtW3Gu4A/io_module.png?psid=4)

Effects module with one clipping effect
![io_module](https://py4mqq.ch.files.1drv.com/y4m3dgfUf1rxceMtUYiJ-Y9GBDS-E2vBBSFrZIh3-UEhRQifIn5Lq2OAAWUWKqsSTMDNNwTtkgEVy9ThtV3UNbjI1OdDDeFvC1tHPhXdbbpdPpasInNJgWDzTLhCE88uy48NYx_IRecy4zoXUrYg9_SaEWggmjloEwWd4KuSFBtSyopP0pHQ07nnUMuo4OyEhdZOfptzF-PS-J2ufYQSEVheg/effect_module.png?psid=1)
