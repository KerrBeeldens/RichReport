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
% - enumitem
% - microtype
% - tgpagella
% - eulervm
% - tgheros
% - babel

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
\RequirePackage{tgheros} % Load in the Heros font
\RequirePackage[english]{babel}

\linespread{1.3} % 1.5 linespacing
\setlength\parindent{0pt} % remove paragraph indentation

% Define colors to be used inside the document
\RequirePackage{xcolor}
\definecolor{headerrule}{RGB}{192, 0, 48}
\definecolor{captionlabel}{RGB}{192, 0, 48}
\definecolor{chapterlabel}{RGB}{192, 0, 48}
\definecolor{sectionlabel}{RGB}{192, 0, 48}
\definecolor{bulletlabel}{RGB}{192, 0, 48}
\definecolor{chaptertoclabel}{RGB}{192, 0, 48}

% Set the document class options
\DeclareOption{twocolumn}{\OptionNotUsed}
% \DeclareOption{green}{\renewcommand{\headerrule}{\color{green}}}
% \DeclareOption{red}{\renewcommand{\headerrule}{\color{blue}}}
\DeclareOption{noindent}{\setlength\parindent{0pt}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions\relax

% Format the header and footers
% TODO: consider setting the footer/header geometry
\RequirePackage{fancyhdr}

% Allow to access the current chapter with \currentchapter
\RequirePackage{silence}

\newcommand{\currentchapter}{}
\let\oldchapter\chapter
\renewcommand{\chapter}[1]{%
  \begingroup
  \WarningFilter{latex}{Marginpar on page} % Suppress "Marginpar on page x moved" warning caused by chapters
  \oldchapter{#1}%
  \renewcommand{\currentchapter}{#1}%
  \endgroup
}

\renewcommand{\headrulewidth}{0pt} % Remove the horizontal rule in the header
\newcommand{\customfootrulewidth}{1pt} % add the horizontal rule in the footer (TODO: make this use footrulewidth)
\setlength{\headheight}{20.00003pt} % Minimum headheight as recommended by fancyhdr

% Formatting for 'standard pages' (non-standard pages would be the titlepage, ToC etc.)
\fancypagestyle{standardpage}{
\fancyhf{} % Remove all formatting of the fancy page style

% Define the header
\fancyheadoffset[L]{\oddsidemargintotalwidth}
\fancyhead[L]{{\textcolor{headerrule}{\rule[-0.75em + 0.25ex]{\oddsidemargintotalwidth - \marginparsep}{2em}}\hspace{\marginparsep}}{\sffamily\chaptername\ \thechapter: \currentchapter}} % Formula for raising rule (\rule[y]{...}{x}) y = - 0.5x + 0.25em + 0.25ex)

% Define the footer
\fancyfoot[L]{\rule[0.5ex]{0.5\textwidth - 1.5em}{\customfootrulewidth}}
\fancyfoot[C]{\thepage}
\fancyfoot[R]{\rule[0.5ex]{0.5\textwidth - 1.5em}{\customfootrulewidth}}
}

\fancypagestyle{ToC}{
\fancyhf{} % Remove all formatting of the fancy page style

% Define the footer
\fancyfoot[C]{\rule[0.5ex]{\textwidth}{\customfootrulewidth}}
}

% Make sure chapter pages share the same footer as standard pages
\fancypagestyle{plain}{
\fancyhead[L] {}
}

% Apply the defined headers and footers
\pagestyle{standardpage}

% Change the format of chapters, sections and subsections
\RequirePackage{titlesec}

% chapter
\reversemarginpar
\newlength{\chapterboxsize}
\setlength{\chapterboxsize}{57pt} % TODO do not hardcode this
\RequirePackage{xstring} % To extract the first character of \chaptername

% Define a box for chapter numbers
\newcommand{\chapterbox}[4][chapterlabel]{\colorbox{#1}{\parbox[c][#2 - 2\fboxsep][c]{#2 - 2\fboxsep}{\centering\color{white}\bf\Huge\StrLeft{#3}{1}#4}}}

% Define a chapter format
\newcommand{\chapterformat}[4][chapterlabel]{}

\titleformat{\chapter}[display]
{\sffamily\LARGE\bfseries\marginpar{%
\hspace*{\marginparwidth-\chapterboxsize}%
\chapterbox{\chapterboxsize}{\chaptername}{\thechapter}%
}}{\chaptertitlename\ \thechapter}{0pt}{\Huge}

% this alters "before" spacing (the second length argument) to -25pt and the "ater" spacing to (25pt)
\newcommand{\chapterskip}{25pt}
\titlespacing*{\chapter}{0pt}{-25pt}{\chapterskip} % Todo check if -25 is back to default

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

% Formatting the ToC
\RequirePackage{titletoc}

\makeatletter
\renewcommand{\tableofcontents}{%
\pagestyle{ToC}
{\sffamily\LARGE\bfseries\marginpar{%
\hspace*{\marginparwidth-\chapterboxsize}%
\chapterbox{\chapterboxsize}{X}{}}%
Test\\[15pt] % Todo 15pt is an estimation, also change test to something better
\contentsname}
  \vspace{\chapterskip}
  \@starttoc{toc}
  \newpage
  \pagestyle{standardpage}
}
\makeatother

% Formatting chapters in the ToC
\newlength{\chaptertocboxsize}
\setlength{\chaptertocboxsize}{2em}

\titlecontents{chapter}
[0pt] 
{\vspace{10pt}}
{
\colorbox{chapterlabel}{\parbox[c][\chaptertocboxsize - 2\fboxsep][c]{\chaptertocboxsize - 2\fboxsep}{\centering\color{white}\bfseries{\small\StrLeft{\chaptername}{1}\thecontentslabel}}}\hspace{\marginparsep}% TODO: replace with chapterbox
\bfseries\large}
{\hspace*{-2.3em}} % When no number is given, TODO
{\hspace{0.5em}\hfill\hspace{0.5em}\bfseries\large\pagename\contentspage}
[\smallskip]

\titlecontents{section}
[\chaptertocboxsize + \marginparsep + 3pt] % TODO: why is the + 3pt needed?
{}
{\color{chaptertoclabel}\thecontentslabel\hspace{1em}}
{\hspace*{-2.3em}}
{\hspace{0.25em}\titlerule*[0.75pc]{.}\contentspage}

\titlecontents{subsection}
[\chaptertocboxsize + \marginparsep + 3pt + 2.3em] % TODO: why is the + 3pt needed (see above) + 2.3em?
{}
{\color{chaptertoclabel}\thecontentslabel\hspace{1em}}
{\hspace*{-2.3em}}
{\hspace{0.25em}\titlerule*[0.75pc]{.}\contentspage}

% Appendix

% Change bullet style for level 1, 2, 3 and 4 for enumerate
\RequirePackage[shortlabels]{enumitem}

% level 1
\renewcommand{\labelenumi}{\textbf{\textcolor{bulletlabel}{\arabic*)}}}

% level 2
\renewcommand{\labelenumii}{\textbf{\textcolor{bulletlabel}{\Alph*)}}}

% level 3
\renewcommand{\labelenumiii}{\textbf{\textcolor{bulletlabel}{\Roman*)}}}

% level 4
\renewcommand{\labelenumiv}{\textbf{\textcolor{bulletlabel}{\alph*)}}}

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
  linkcolor = black,
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