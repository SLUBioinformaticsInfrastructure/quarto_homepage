---
title: "How to: Dardel"
description: Starting off with PDC and Dardel
---

The [PDC Center for High Performance Computing](https://www.pdc.kth.se/about/what-does-pdc-do-and-how/introduction-to-pdc-1.736562) is a high-performance computing resource hosted at the KTH Royal Institute of Technology in Stockholm. It is part of the National Academic Infrastructure for  Supercomputing in Sweden ([NAISS](https://www.naiss.se/)). As all NAISS infrastructure, it is open to all researchers within Sweden free of charge. 


## Dardel Training & Drop-in
PDC offers regular training to improve usage of their systems. For a regularly updated list, please see [here](https://www.pdc.kth.se/training).

Once per month they offer an online [drop-in](https://www.pdc.kth.se/training/naiss-zoom-ins-1.927311) to discuss services and help directly with problems.

## Applying for an account at SUPR NAISS

In order use any NAISS resource, you need to apply for an account at [SUPR NAISS](https://supr.naiss.se/login/).

You will also use this page to log on when appying for projects.

## Applying for projects at Dardel
Here is the link to the official documentation on how to [get access](https://support.pdc.kth.se/doc/getting_access/get_access/) to Dardel. 

The following  is a small rundown of this information based on our experience.

More often than not, small compute and small storage projects are enough for the bioinformatics projects we see at SLU. You must apply for a storage project alongside a compute project if you are planning to do any analyses.

The administrators at NAISS approve projects at least once a month, but often more frequently.

When you have [logged in to SUPR](https://supr.naiss.se/login/), there will be a list of options in the panel on the left, select 'Proposals' to see your [proposals](https://supr.naiss.se/proposal/), scroll down to 'Rounds and 'Resources', and click on 'Go to Rounds' to get to the [application](https://supr.naiss.se/round/?).

From here you can apply for computing and storage projects.

### Computing Projects
Select ```Compute Rounds``` followed by ```NAISS Small Compute```

You will then select ```Create New Proposal for NAISS Small Compute 2025``` 

We generally recommend asking for 2 or 3 x1000 core hours per month. This can always be increased later if you realise that you exceed this boundary, but that is quite rare.


### Storage Projects
Select ```Go to Storage Rounds``` followed by ```NAISS Small Storage```

Here you will have to request the size of the project folder as well as the number of files you will be storing.

As a general rule of thumb:

* **For folder size**: multiply the size of the data you are uploading by 5-7, depending on the analysis you will be doing. If the size of your files decreases with each step of your pipeline (and you remove large intermediate files during your workflow) as with variant calling for example, a factor of 5 is usually more than enough. If you are performing multiple genome alignments from *de novo* assemblies, for example, your file sizes don't decrease significantly between each step of the pipeline, then you should multiply by a higher factor of 7 (or higher, depending on what you will be doing).

* **For number of files**: multiply the number of files you are starting out with by 1000. If you are using Nextflow workflows, this number may have to be a bit higher (but should not exceed 5000) as the number of intermediate files produced here is higher due to parallelisation.


In short, consider the analyses you will be doing, what kind of data you are producing, and how big the files are. With these two **very** general rules, it should be easier to decide on these parameters when applying for projects!

When your storage and compute projects have been approved, you will be able to upload data from your computer, or download from data delivery systems. If you are downloading from SciLifeLab, please see their [guide](https://ngisweden.scilifelab.se/resources/data-delivery-dds/).

Your approved projects will be located under ```/cfs/klemming/projects/supr/naiss202x_xy_xyz``` where xyz are the project identifiers provided to you by NAISS.

After your storage and compute projects have been approved, you can navigate to your folder in the ```/cfs/klemming/projects/supr/``` directory and upload your data in your **storage** project folder. **DO NOT** upload your data to your user home directory as that directory is only intended for things you will use for every project and space is limited.

::: {.callout-note}
Dardel has a much stricter attitude towards number of files in your home directory than some other servers. Be very mindful of how many files you have in your home directory!
:::

## Logging in for the first time
Please see the [comprehensive version from the staff of Dardel](https://support.pdc.kth.se/doc/basics/quickstart/). You will need to [create SSH keys](https://support.pdc.kth.se/doc/login/ssh_keys/) and log them with SUPR. 

### Windows

If you are trying to access Dardel from a Windows machine, you will have to use [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/). This is the same program you will have used to generate the SSH key. Follow these [instructions](https://jumpcloud.com/support/manage-ssh-keys-in-putty) on how to manage your SSH keys. Unfortunately the team at Dardel do not offer support for VSCode on Windows machines.

### MacOS and Unix

You are able to use VSCode or VSCodium to log on to Dardel. When you add Dardel to your list of known hosts, you need to specify the location of the key on your machine in your `.shh/config` file. Here is an example:

```{.bash}
Host dardel
   IdentityFile $path_to_your_key
   HostName dardel.pdc.kth.se
   User $your_username
```

If you log on with VSCode frequently, it will automatically download a number of files for the VSCode interface. At some point, you may not be able to log in with VSCode anymore because the required environment cannot be downloaded. In that case, log in via the terminal with a traditional `ssh` login, and clear the `.vscode-server` folder and log in from VSCode again.

## Loading modules

Klemming, the storage system on Dardel, uses modules. This ensures that the path is not flooded, and allows for multiple versions of software to be installed simultaneously. 

* To see all available modules type ```module avail``` 
* If you want to see the modules that match your search term type ```module spider tool_name```. This is not case specific, so you could search "fastqc" to see all modules that match the string "fastqc" (without the inverted commas!)
* To load a module type ```module load tool_name``` from the ```module spider``` results. This is case specific, so be sure to 

Check out the list of [list of software installed on Dardel](https://support.pdc.kth.se/doc/applications/). 

To learn more about the module system, have a look at the guide on [Dardel](https://support.pdc.kth.se/doc/software/module/).

##  Slurm
Dardel uses a job manager called [Slurm](https://slurm.schedmd.com/documentation.html), and they have put a [how-to onto their homepage](https://support.pdc.kth.se/doc/run_jobs/job_scripts/). The following is simply a short overview of the most commonly used functions by SLUBI, and not an exhaustive list:

To use Slurm, the project ID from your **compute** project is used for the **-A** flag. Your storage project ID is where you store data. Here, the / and spaces in the name are replaced by - as you can see below.

More usefull flags and options:

* Time flags are in the format of HH:MM:SS
* To run an interactive session use ```interactive -A naiss202x-xy-xyz -t 2:00:00``` to launch an interactive session of 2 hours. Time can be changed according to your needs
* If you need to run a batch script, set it up so that the information in the [Dardel guide](https://support.pdc.kth.se/doc/run_jobs/job_scripts_dardel/) is in the header with your project number. You submit your script with the ```sbatch script.sh``` command
* To view the jobs active for your user ```squeue -u your_username```
* To cancel a job ```scancel jobnumber```. You can get the jobnumber from the ```squeue``` command above.

## Dardel Miscellaneous

We have a GitHub repository where we gather small tips and tricks that make working on Dardel easier: 

[GitHub: Dardel Miscellaneous](https://github.com/SLUBioinformaticsInfrastructure/Dardel_miscellaneous)


## Nextflow on Dardel

On our GitHub page, we also have a repository with some helpful tips to [run nf-core pipelines on Dardel](https://github.com/SLUBioinformaticsInfrastructure/nf-core_on_dardel). In this repo, we guide you through the process of installing Pixi, an environment and package manager, and running Nextflow and nf-core through there. While Nextflow and nf-core are installed on Dardel, sometimes there are pipelines with different version requirements.