%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Document Class Information      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This document class is intended to be used as a replacement for the 'report' document class.
% This package is created by Kerr Beeldens

% This class is dependent on the following packages:
% - calc
% - fancyhdr

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{richreport}[2024/03/11 Rich documentclass for reports, intended to be used as a replacement for the 'report' document class.]

\LoadClass{report} % TODO: figure out where to place this

% Calculate some lenghts based on page geometry 
\RequirePackage{calc}

\newlength{\oddsidemargintotalwidth}
\setlength{\oddsidemargintotalwidth}{1 in + \hoffset + \oddsidemargin}

\setlength{\marginparsep}{15pt}

% Define colors to be used inside the document
\usepackage{xcolor}
\definecolor{headerrule}{RGB}{255, 0, 0}

% Define how links should be displayed, among other useful settings
\RequirePackage{hyperref}

% Format the header and footers
% TODO: consider setting the footer/header geometry
\RequirePackage{fancyhdr}
\RequirePackage{nameref} % Used to be able to display the current chapter with

% Allow to access the current chapter with \currentchapter
\newcommand{\currentchapter}{}
\let\oldchapter\chapter
\renewcommand{\chapter}[1]{%
  \oldchapter{#1}%
  \renewcommand{\currentchapter}{#1}%
}

\renewcommand{\headrulewidth}{0pt} % Remove the horizontal rule in the header
\newcommand{\customfootrulewidth}{1pt} % add the horizontal rule in the footer (TODO: make this use footrulewidth)
\setlength{\headheight}{20.00003pt} % Minimum headheight as recommended by fancyhdr

\fancypagestyle{standardpage}{
\fancyhf{} % Remove all formatting of the fancy page style

% Define the header
\fancyheadoffset[L]{\oddsidemargintotalwidth}
\fancyhead[L]{{\textcolor{headerrule}{\rule[-0.75em + 0.25ex]{\oddsidemargintotalwidth - \marginparsep}{2em}}\hspace{\marginparsep}}{\sffamily\chaptername\ \thechapter. \currentchapter}} % Formula for raising rule (\rule[y]{...}{x}) y = - 0.5x + 0.25em + 0.25ex)

% Define the footer
\fancyfoot[L]{\rule[0.5ex]{0.5\textwidth - 1.5em}{\customfootrulewidth}}
\fancyfoot[C]{\thepage}
\fancyfoot[R]{\rule[0.5ex]{0.5\textwidth - 1.5em}{\customfootrulewidth}}
}

% Apply the defined headers and footers
\pagestyle{standardpage}

\endinput