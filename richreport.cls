%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Document Class Information      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This document class is intended to be used as a replacement for the 'report' document class.
% This Document Class is created by Kerr Beeldens

% This class is dependent on the following packages:
% - calc
% - fancyhdr
% - hyperref
% - caption
% - fontawesome
% - titlesec

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{richreport}[2024/03/11 Rich documentclass for reports, intended to be used as a replacement for the 'report' document class.]

\LoadClass{report} % TODO: figure out where to place this

% Calculate some lenghts based on page geometry 
\RequirePackage{calc}

\newlength{\oddsidemargintotalwidth}
\setlength{\oddsidemargintotalwidth}{1 in + \hoffset + \oddsidemargin}

\setlength{\marginparsep}{15pt}

% Define general formatting of the type
\RequirePackage{microtype} % Improves justified content

\RequirePackage{tgpagella} % Loads in the Pagella font
\renewcommand*{\bfdefault}{bx} 
\RequirePackage{eulervm} % Load in the EulerVM font

\linespread{1.3} % 1.5 linespacing
\setlength\parindent{0pt} % remove paragraph indentation

% Define colors to be used inside the document
\RequirePackage{xcolor}
\definecolor{headerrule}{RGB}{255, 0, 0}
\definecolor{captionlabel}{RGB}{0, 255, 0}
\definecolor{chapterlabel}{RGB}{127, 0, 127}
\definecolor{sectionlabel}{RGB}{0, 0, 255}

% Format the header and footers
% TODO: consider setting the footer/header geometry
\RequirePackage{fancyhdr}

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

% Make sure chapter pages share the same footer as standard pages
\fancypagestyle{plain}{
\fancyhead[L] {}
}

% Apply the defined headers and footers
\pagestyle{standardpage}

\usepackage{titlesec}

% Change the format of chapters, sections and subsections

% chapter
\reversemarginpar
\newlength{\chapterboxsize}
\setlength{\chapterboxsize}{60pt} % TODO do not hardcode this

\titleformat{\chapter}[display]
{\sffamily\huge\bfseries}{\marginpar{%
\hspace*{\marginparwidth-\chapterboxsize}%
\colorbox{chapterlabel}{\parbox[c][\chapterboxsize - 2\fboxsep][c]{\chapterboxsize - 2\fboxsep}{\centering\color{white}\bf\Huge H\thechapter}}%
}\chaptertitlename\ \thechapter}{0pt}{\Huge}

% this alters "before" spacing (the second length argument) to -25pt and the "ater" spacing to (25pt)
\titlespacing*{\chapter}{0pt}{-25pt}{25pt}

\newcommand{\marginsecnumber}[1]{%
  \makebox[0pt][r]{#1\hspace{\marginparsep}}% TODO: does this work with odd/even pages?
}

% Section
\titleformat{\section}
  {\sffamily\Large\bfseries}
  {\color{sectionlabel}\marginsecnumber\thesection}
  {0pt}
  {}

% Subsection
\titleformat{\subsection}
  {\sffamily\large\bfseries}
  {\color{sectionlabel}\marginsecnumber\thesubsection}
  {0pt}
  {}

% Format captions
\RequirePackage{caption} % Used to get options to format captions
\RequirePackage{fontawesome} % Used to get useful icons like \faCamera and \faTable

% Format figure captions
\DeclareCaptionFormat{figure}{\textcolor{captionlabel}{\footnotesize{\faCamera}\normalsize\bf\ #1#2}#3}
\captionsetup[figure]{format=figure} 

% Format table captions
\DeclareCaptionFormat{table}{\textcolor{captionlabel}{\footnotesize{\faTable}\normalsize\bf\ #1#2}#3}
\captionsetup[table]{format=table} 

% Define how links should be displayed and add PDF Metadata
\RequirePackage[
  colorlinks = true,
  citecolor = blue,
  filecolor = blue,
  linkcolor = blue,
  urlcolor = blue,
  runcolor = blue,
  % pdftitle, % TODO
  % pdfauthor, % TODO
  % pdfsubject, % TODO
  % pdfkeywords, % TODO
  % pdfcreationdate, TODO
  % pdfmoddate, TODO
  % pdflang?, % TODO
  pdfcreator = Created\ using\ 'richreport'\ by\ Kerr\ Beeldens
]{hyperref}

\endinput