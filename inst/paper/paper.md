---
title: 'openmpp: An R package for dynamic microsimulation modeling using OpenM++'
tags:
- R
- microsimulation
date: "12 August 2024"
authors:
- name: Matthew T. Warkentin
  orcid: 0000-0001-8730-3511
  email: matthew.warkentin@ucalgary.ca
  affiliation: 1
- name: Yibing Ruan
  email: Yibing.Ruan@albertahealthservices.ca
  affiliation: 1
- name: John M. Hutchinson
  email: john.hutchinson@ucalgary.ca
  affiliation: 1
- name: Darren R. Brenner
  email: darren.brenner@ucalgary.ca
  affiliation: 1
affiliations:
- name: Department of Oncology, Cumming School of Medicine, University of Calgary, Calgary, AB, Canada
  index: 1
bibliography: paper.bib
---

# Summary

Dynamic microsimulation is a computational technique used to simulate the behavior of individual entities (i.e., micro) within a population over time. It combines elements of microeconomics, demography, and statistical modeling to create detailed simulations of complex systems. Dynamic microsimulation involves creating a synthetic population representative of the real population and modeling the life paths of individuals based on various demographic and socioeconomic characteristics. Unlike static models that provide snapshots of a population at a single point in time, dynamic microsimulation models capture the interactions and changes that occur over time, allowing researchers to analyze the long-term effects of demographic shifts, policy changes, as well as clinical or population intervention. These models can then be used to predict future population trends and assess the impact of policy changes or interventions on health, resource, and economic outcomes. Dynamic microsimulation is used across a wide range of disciplines, including economics, public policy, epidemiology, urban planning, and environmental science. In public health research, dynamic microsimulation models are used to forecast disease trends, evaluate the impact of healthcare interventions, and plan for future healthcare needs. Overall, dynamic microsimulation provides a powerful framework for understanding the complex dynamics of trends within a population to inform evidence-based decision-making across a variety of fields.

[OpenM++](https://openmpp.org/index.html) is an open-source software platform designed for dynamic microsimulation modeling [@OpenMpp]. It provides a flexible framework and language for researchers and policymakers to build, calibrate, and analyze complex dynamic microsimulation models. OpenM++ offers a user-friendly interface and a powerful domain-specific language, allowing users to define intricate demographic, economic, and behavioral processes within a simulated population. With its modular architecture, OpenM++ enables easy integration of various data sources and model components, facilitating interdisciplinary research and policy analysis. The OpenM++ platform is widely used in academia, government agencies, and research institutions to explore the long-term impacts of policy interventions, demographic changes, and economic trends on populations and societies. However, while the OpenM++ graphical interface is simple to learn, the graphical interface may impede users with more complicated modelling needs and limits the transparency and reproducibility of analyses. The OpenM++ software provides an application programming interface (API) that enables programmatic interactions with data and models using scripting languages (e.g., R).

The [`openmpp`](https://github.com/mattwarkentin/openmpp) R package provides a programmatic interface to the OpenM++ API [@openmpp] to simplify the process of creating and managing microsimulations, performing scalable and reproducible computations, and gathering results adhereing to tidy data principles [@tidyverse] for further processing and reporting. OpenM++ can run on local machines, servers, or cloud infrastructure (i.e., remotely). [`openmpp`](https://github.com/mattwarkentin/openmpp) supports connectivity and secure user authentication for both local and remote connections to OpenM++ from an R session. A user may wish to define many scenarios to evaluate using dynamic microsimulation. Manual approaches to managing these scenarios and runs can be onerous and lack transparency or reproducibility. Programmatic approaches for creating and managing scenarios enables scalability and reproducibility. Boilerplate code for running microsimulations (with configurable options) encourages rapid prototyping and iteration before running simulations at scale. Lastly, output tables and reports should be kept up to date with the most recent microsimulations. The [`openmpp`](https://github.com/mattwarkentin/openmpp) package enables importing output tables directly into R to encourage reproducible reporting with no intermediate or temporary files. The package provides a suite of functions for easy communication with the OpenM++ API, including a set of R6 classes that enable real-time communication to ensure that all changes made to microsimulation objects in the R session are propagated and synchronized with the OpenM++ database. R6 provides the infrastructure to abstract away the technical debt required to send and receive data when communicating with the API [@R6]. Users can interact with R objects in a familiar way while achieving real-time synchronization with external resources. Encapsulated object-oriented programming (OOP) allows the internal state of the object (i.e., the connection to the actual object in the OpenM++ database) to be accessed and modified only through well-defined methods, rather than directly manipulating the data, which enforces data integrity, improves code readability, and simplifies maintenance by abstracting away the implementation details of an object and preventing unintended modifications to its state.

OpenM++ is a powerful open-source software and domain-specific language for dynamic microsimulations. The [`openmpp`](https://github.com/mattwarkentin/openmpp) package provides a programmatic interface to OpenM++ to simplify the process of connecting to local or remote servers with secure user authentication, creating, managing, and running large-scale and complex microsimulations, and gathering results for reproducible reporting.

# References
