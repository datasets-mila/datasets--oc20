##################
Open Catalyst 2020
##################

`<https://github.com/Open-Catalyst-Project/ocp/blob/master/DATASET.md>`_

.. note:: Data files for all tasks / splits were updated on Feb 10, 2021 due to
   minor bugs (affecting < 1% of the data) in earlier versions. If you
   downloaded data before Feb 10, 2021, please re-download the data.

This page summarizes the dataset download links for S2EF and IS2RE/IS2RS tasks
and various splits. The main project website is
`<https://opencatalystproject.org/>`_

******************************************
Structure to Energy and Forces (S2EF) task
******************************************

For this task’s train and validation sets, we provide compressed trajectory
files with the input structures and output energies and forces. We provide
precomputed LMDBs for the test sets. To use the train and validation datasets,
first download the files and uncompress them. The uncompressed files are used
to generate LMDBs, which are in turn used by the dataloaders to train the ML
models. Code for the dataloaders and generating the LMDBs may be found in the
Github repository.

Four training datasets are provided with different sizes. Each is a subset of
the other, i.e., the 2M dataset is contained in the 20M and all datasets.

Four datasets are provided for validation set. Each dataset corresponds to a
subsplit used to evaluate different types of extrapolation, in domain (id, same
distribution as the training dataset), out of domain adsorbate (ood_ads, unseen
adsorbate), out of domain catalyst (ood_cat, unseen catalyst composition), and
out of domain both (ood_both, unseen adsorbate and catalyst composition).

Each tarball has a README file containing details about file formats, number of
structures / trajectories, etc.

********
Citation
********

The Open Catalyst 2020 (OC20) dataset is licensed under a `Creative Commons
Attribution 4.0 License
<https://creativecommons.org/licenses/by/4.0/legalcode>`_. Please cite the
following paper in any research manuscript using the OC20 dataset:

::

    @article{ocp_dataset,
        author = {Chanussot*, Lowik and Das*, Abhishek and Goyal*, Siddharth and Lavril*, Thibaut and Shuaibi*, Muhammed and Riviere, Morgane and Tran, Kevin and Heras-Domingo, Javier and Ho, Caleb and Hu, Weihua and Palizhati, Aini and Sriram, Anuroop and Wood, Brandon and Yoon, Junwoong and Parikh, Devi and Zitnick, C. Lawrence and Ulissi, Zachary},
        title = {Open Catalyst 2020 (OC20) Dataset and Community Challenges},
        journal = {ACS Catalysis},
        year = {2021},
        doi = {10.1021/acscatal.0c04525},
    }
