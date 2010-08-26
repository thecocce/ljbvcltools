{*********************************************************}
{    Turbo Pascal-Routinen zum Identifizieren von 187     }
{       verschiedenen Typen komprimierter Dateien         }
{                                                         }
{    Turbo Pascal routines to identify 187 different      }
{            types of compressed files                    }
{                                                         }
{           Version 3.14.07 / 12.06.2003                  }
{                             06-12-2003                  }
{                                                         }
{            (C) 1994-2003, Juergen Peters                }
{                                                         }
{       eMail : uu@graybeast.de                           }
{       WWW   : http://www.graybeast.de                   }
{       FTP   : ftp://graybeast.dyndns.org                }
{               ftp://graybeast.2y.net                    }
{               ftp://graybeast.dyn.ee                    }
{               ftp://graybeast.dyns.cx                   }
{               (wenn eine URL nicht funktioniert,        }
{                andere probieren)                        }
{               (if one URL doesn't work try another)     }
{                                                         }
{                 Released as Freeware                    }
{                                                         }
{ Dieser Source ist noch in keinster Weise optimiert, er  }
{ tut lediglich, was er soll (hoffe ich).                 }
{ Eine Dokumentation gibt es auch nicht, aber ich glaube, }
{ es dÅrfte auch so alles klar sein...                    }
{ Der Autor Åbernimmt keine Haftung fÅr irgendetwas ;-))  }
{                                                         }
{ This source isn't yet optimized in any way, it simply   }
{ does, what it is intended to do (hopefully).            }
{ Another documentation than the comments in it is not    }
{ available, but I hope it's all clear nevertheless.      }
{ The author is not to be made responsible for anything   }
{ this source does to your computer... ;-))               }
{*********************************************************}

{ Letzte énderungen: 04.04.95: - Erkennung von BSN-EXE-Dateien verbessert }
{           1.53:    13.05.95: - Erkennung von AIN-Dateien verbessert     }
{                              - Packer BS2/BSArc und GZIP hinzugefÅgt    }
{           1.54:    20.05.95  - Packer ACB hinzugefÅgt                   }
{                    21.05.95  - Packer MAR hinzugefÅgt                   }
{                              - ACB-Erkennung verbessert                 }
{           1.55:    24.05.95  - Packer CPShrink hinzugefÅgt              }
{                              - Packer JRC hinzugefÅgt                   }
{                              - Packer JARCS hinzugefÅgt                 }
{                              - Packer Quantum hinzugefÅgt               }
{                              - Packer ReSOF hinzugefÅgt                 }
{                    25.05.95  - Erkennt nun auch BSN-Sfxes, die nicht    }
{                                die Extension .EXE haben                 }
{           2.00     27.05.95  - Archiveinleseroutinen komplett Åberarbei-}
{                                tet. Archivheader wird jetzt in einen    }
{                                Puffer eingelesen, dadurch gro·er Ge-    }
{                                schwindigkeitsgewinn                     }
{                              - Ungepackte Crush-Dateien hinzugefÅgt     }
{                              - Packer ARX (LHArc-Clone) hinzugefÅgt     }
{                    02.06.95  - Erkennt Sfx-Dateien von UC2 Pro          }
{           2.01     06.06.95  - Erkennt mit UCEXE gepackte Files         }
{                    08.06.95  - Erkennung von WWPack (EXE-Packer)        }
{           2.02     12.06.95  - Formate von YAC und Quark werden erkannt }
{           2.03     18.06.95  - Probleme mit 0 Byte-Files und Lesen nach }
{                                Dateiende beseitigt (Dank an Christoph   }
{                                Schuppius fÅr den Hinweis!)              }
{                    27.06.95  - ACB 1.07-Erkennung                       }
{                    29.06.95  - Bugfix bei Funktion IsEXE                }
{           2.04     01.07.95  - Auch RAR-OS/2-Sfx-Dateien werden erkannt }
{                    02.07.95  - X1-eigenes Format wird erkannt           }
{                    05.07.95  - Codec- und Codec-DOS-Sfx werden erkannt  }
{                              - AMGC-Format wird identifiziert           }
{                              - NuLIB-Format wird erkannt                }
{                              - PAKLeo-Format wird erkannt               }
{                    09.07.95  - Format TGZ wird erkannt                  }
{                              - WWPack-Datafile wird erkannt             }
{                              - ACB 1.08a wird identifiziert             }
{                    18.07.95  - ACB 1.10a, ChArc und PSA werden erkannt  }
{                    20.07.95  - Format ZAR wird erkannt                  }
{                    27.07.95  - FÑlschlicherweise wurden viele ungepackte}
{                                EXE-Dateien als ZAR-Archive erkannt      }
{                    29.07.95  - Auch Read Only-Files werden jetzt erkannt}
{                    09.08.95  - ACB 1.13a wird identifiziert             }
{                    19.08.95  - Erneut ZAR-Bugfix                        }
{                    25.08.95  - Format TPK wird als LZS-Clone erkannt    }
{           2.05     06.10.95  - Verbesserte FileExist-Routine            }
{                    07.10.95  - Packer LHARK (-lh7-) wird erkannt        }
{           2.06     03.11.95  - ACB 1.14a wird identifiziert             }
{                    04.11.95  - CrossePAC, Freeze, KBoom und NSQ werden  }
{                                erkannt                                  }
{                    14.11.95  - Format DPA wird identifiziert            }
{           2.07     20.02.96  - ACB 1.15b-Format wird erkannt            }
{                    22.02.96  - ACB 1.17a-Format wird identifiziert      }
{                    27.02.96  - ACB 1.20a wird erkannt                   }
{                    29.02.96  - ACB-Erkennung verallgemeinert; nicht mehr}
{                                jede Version mu· einzeln identifiziert   }
{                                werden                                   }
{           2.08     31.05.96  - Format TTComp wird erkannt               }
{           2.09     10.08.96  - Format WIC wird identifiziert, obwohl es }
{                                sich bei dem Packer um einen Fake handelt}
{                                (packt nicht wirklich, legt nur eine     }
{                                versteckte Datei WINFILE.DLL an, die die }
{                                angeblich gepackten Daten enthÑlt)       }
{           2.10     24.10.96  - Format von RKive wird erkannt            }
{                    31.10.96  - Bugfixes                                 }
{                              - Format JAR wird identifiziert            }
{                    12.11.96  - Kleinere Bugfixes                        }
{           2.11     15.11.96  - EXEPacker-Erkennung LZExe, PKLite, Diet  }
{                                und TinyProg integriert                  }
{           2.12     08.12.96  - Packer ESP wird erkannt                  }
{                              - Format ZPack wird identifiziert          }
{           2.13     08.01.97  - Erste deutsch-englische Version          }
{                    01.02.97  - Format DRY (Dehydrated) wird erkannt     }
{                    03.02.97  - Format OWS wird identifiziert, obwohl es }
{                                sich bei dem Packer um einen Fake handelt}
{                                (packt nicht wirklich)                   }
{           2.14     23.02.97  - Format SKY wird erkannt                  }
{                    24.02.97  - RKive-Erkennung verbessert               }
{           2.15     08.03.97  - ZAR wurde manchmal als TTComp erkannt    }
{                              - Format ARI wird notdÅrftig (anhand der   }
{                                Dateiextension .ARI) erkannt             }
{                              - Format UFA wird identifiziert            }
{                    09.03.97  - Microsofts CAB (Windows 95) wird erkannt }
{                    11.03.97  - Bugfix: einige Archive wurden nur        }
{                                erkannt, wenn der Archivname gro·ge-     }
{                                schrieben war                            }
{                    12.03.97  - Erkennung von FOXSQZ                     }
{                    16.03.97  - Erkennung von AR7                        }
{                    18.03.97  - Identifizierung des Stirling-Compressors }
{                    22.03.97  - Erkennung von PPMZ                       }
{           2.16     30.03.97  - MS Compress hinzugefÅgt                  }
{                    02.04.97  - Erkennung von MP3 und ZET                }
{           2.17     07.04.97  - Erkennung von XPack-Data- und Diskimage- }
{                                Dateien                                  }
{                    17.04.97  - Identifiziert ARQ-Archive                }
{           2.18     27.04.97  - Erkennt ACE-Archive                      }
{                    10.05.97  - Packer Squash (D. Murk) wird erkannt     }
{           2.19     14.05.97  - ACE-Sfx-Erkennung verbessert             }
{                              - Packer Terse wird identifiziert          }
{                    17.05.97  - XPack-Single Data File wird erkannt      }
{           2.20     21.05.97  - Erkennt BS Archiver 1.6 (Ñltere Form von }
{                                BSA (PTS-DOS)) als BSN                   }
{                    24.05.97  - Auch ACE 0.9c5 und 0.9d1 Junior Sfx      }
{                                werden erkannt                           }
{                              - Stuffit (Mac) wird identifiziert         }
{                              - Erkennung von PKZip-Windows- und OS/2-   }
{                                Sfxes und WinRAR-Install-Sfxes verbessert}
{           2.21     25.05.97  - Wegen Schwierigkeiten mancher Ñlterer    }
{                                Unpacker mit Multitaskern (z.B. PKUnpak  }
{                                unter OS/2) îffnet IDPACKER die Archive  }
{                                nun im Sharing-Modus (permit all)        }
{                    01.06.97  - PUCrunch wird identifiziert              }
{                    04.06.97  - ACE 0.9d3-Sfx wird erkannt               }
{                    05.06.97  - BZip wird identifiziert                  }
{           2.22     08.06.97  - ACE 0.9d4-Sfx wird erkannt               }
{                    09.06.97  - Folgende Multiple Volume-Archive werden  }
{                                nicht mehr nur anhand der Dateiextension,}
{                                sondern am Volume-Flag im Archivheader   }
{                                erkannt: ARJ, ARJ-Sfx, RAR, RAR-Sfx, ACE }
{          2.23      18.06.97  - Erkennung von ACE 0.9e3-Sfx              }
{                    20.06.97  - Erkennung von PKZip/2 2.50-Sfx           }
{                    23.06.97  - Bugfix: Bei Wildcards in Archivnamen     }
{                                wurden Sfxes teilweise nicht erkannt     }
{          2.24      19.07.97  - Erkennung von UHarc 0.1.66               }
{                    23.07.97  - Bei folgenden Formaten wird am AV-Flag   }
{                                im Archivheader erkannt, ob sie einen    }
{                                AV-Envelope haben oder "locked" sind:    }
{                                ARJ, ARJ-Sfx, RAR, RAR-Sfx, ACE          }
{                    03.08.97  - Bugfix bei IsEXE(): die Variable FileMode}
{                                wurde evtl. nicht zurÅckgesetzt          }
{                                (Dank an Ralph Roth)                     }
{                    04.08.97  - Format ABComp ab 2.04b wird erkannt      }
{                    18.08.97  - Format CMP (AndrÇ Olejko) wird erkannt   }
{                    20.08.97  - Kleinere Bugfixes                        }
{          2.25      24.08.97  - BZip2 wird erkannt                       }
{          2.26      25.08.97  - Erkennt BS Archiver 1.9 (Ñltere Form von }
{                                BSA (PTS-DOS)) als BSN                   }
{                              - Erkennt LZOP (M.-F.-X.-J. Oberhumer)     }
{          2.27      26.08.97  - Bessere Unterscheidung ARC/PAK           }
{                                (Dank an George Shadoff)                 }
{          2.28      28.08.97  - Bugfix bei ARJ-AV-Erkennung              }
{                              - "Rohe" szip-Erkennung (nach nur einem    }
{                                Byte und Extension .sz)                  }
{                    31.08.97  - WinZip-Sfxes werden (als ZIP) erkannt    }
{                    09.09.97  - Format Splint wird erkannt               }
{                    14.09.97  - Funktion IsEXE: DOS-EXEs kînnen auch mit }
{                                'ZM' statt 'MZ' beginnen (Dank an Pierre }
{                                Foucart).                                }
{          2.29      17.09.97  - Format TAR wird (nur an der Extension    }
{                                .TAR) erkannt.                           }
{                              - InstallShield-Format wird erkannt        }
{          2.30      24.09.97  - Codec-Erkennung verbessert               }
{                              - ZIP-Archiv-Erkennung verbessert          }
{                              - Limit-Erkennung verbessert               }
{                              - Format CARComp wird (nur an der Extension}
{                                .CAR) erkannt                            }
{                    26.09.97  - Bessere Erkennung von WinRAR (inkl. 2.02)}
{                    29.09.97  - LZS erhÑlt eigenen Archivtyp             }
{          2.31      11.10.97  - Auch 32 Bit-WinZip-Sfxes werden (als ZIP)}
{                                erkannt                                  }
{                    13.10.97  - Weiteres Windows-Install-Sfx-Format (ZIP)}
{                                hinzugefÅgt                              }
{                    14.10.97  - Dateizugriffsmodus simplifiziert         }
{                    15.10.97  - Manchmal wurden LHark-Archive als AIN    }
{                                erkannt                                  }
{          2.32      01.11.97  - Format BOA wird identifiziert            }
{                              - InstallShield-Z-Format wird erkannt      }
{                    08.11.97  - Formate ARG und Gather (GTH) werden erk. }
{                              - RKive 1.9 wird identifiziert.            }
{          2.33      27.11.97  - Formate Pack Magic, Big Tree Software    }
{                                Archiver, ELI 5750 und QFC werden erkannt}
{                    06.12.97  - PRO-PACK wird identifiziert              }
{                              - WinZip32-Erkennung weiter verbessert     }
{                    01.01.98  - MSXiE von Mercury Soft Technology wird   }
{                                erkannt                                  }
{                    17.01.98  - Weitere WinZip-Variante wird identifiz.  }
{          2.34      31.01.98  - Format RAX wird erkannt                  }
{                    01.03.98  - Format 777 (Win32) wird identifiziert    }
{          2.35      12.04.98  - Formate LZS221 (Stac), HPA (Hungarian    }
{                                Pirate Alliance), Arhangel (George       }
{                                Lyapko), EXP1 (Bulat Ziganshin) und IMP  }
{                                werden erkannt                           }
{                    20.04.98  - BMF (komprimiertes Grafikformat) wird    }
{                                erkannt                                  }
{                    29.04.98  - NRV (Demo von Markus Oberhumer) wird     }
{                                identifiziert                            }
{                    30.04.98  - PAK 1.0a (Dmitry Dvoinikov) wird erkannt }
{          2.36      08.05.98  - Squisch (Mike Albert) wird identifiziert }
{                              - PRO-PACK 2.14 (mit anderem Header) wird  }
{                                erkannt                                  }
{                              - ParB (Win32-Archiver) wird identifiziert }
{                    10.05.98  - PAK 1.0a-Erkennung verbessert            }
{                    13.05.98  - ARX-Erkennung verbessert                 }
{                    17.05.98  - WinRAR-Erkennung optimiert               }
{          2.37      05.06.98  - Formate HIT (Bogdan Ureche) und SBX      }
{                                werden identifiziert                     }
{                    09.06.98  - Weitere WinZip-Sfx-Variante wird erkannt }
{          2.40      14.06.98  - szip-Erkennung verbessert (Dank an       }
{                                Michael Schindler fÅr Infos)             }
{                              - Erkennung der alten Sfx-Formate LHarc und}
{                                LARC verbessert                          }
{          2.41.00   01.07.98  - Indentifizierung des NSK-Formats         }
{          2.41.01   03.07.98  - Weiteres WinZip-32 Bit-Sfx erkannt       }
{          2.41.02   11.07.98  - Format DST (Disintegrator 0.9b, Tommaso  }
{                                Gugli) wird erkannt                      }
{          2.41.03   12.07.98  - ASD (Tobias Svensson) wird identifiziert }
{          2.42.00   03.08.98  - Zur besseren Errorlevel-Auswertung werden}
{                                unbekannte Archive/Nichtarchivdateien    }
{                                nicht mehr als Typ 0, sondern 251 erkannt}
{          2.42.01   12.08.98  - SZip-Bugfix                              }
{          2.42.02   17.08.98  - Erkennung von BTSPK verbessert           }
{          2.42.03   23.08.98  - InstallShield-CAB wird erkannt           }
{          2.42.04   02.09.98  - QFC 2.0 wird erkannt                     }
{          2.42.05   10.09.98  - TOP4 und Batcomp (4DOS) werden erkannt   }
{          2.42.06   11.09.98  - Kleinere Bugfixes                        }
{          2.42.07   12.09.98  - TOP4- und Batcomp-Erkennung prÑzisiert   }
{          2.42.08   14.10.98  - BlakHole (Win32) wird erkannt            }
{          2.43.00   02.12.98  - BIX (Igor Pavlov) wird identifiziert     }
{          2.43.01   15.01.99  - ChiefLZA wird erkannt                    }
{          2.50.00   14.02.99  - Bei Einbindung von LFN.PAS von Andreas   }
{                                Killer ($DEFINE LONGNAME) werden lange   }
{                                Dateinamen unter Windows unterstÅtzt     }
{          2.50.01   24.02.99  - Blink von D.T.S. wird erkannt            }
{          2.50.02   01.03.99  - CAR von MylesHi! Software wird erkannt   }
{          2.50.03   07.03.99  - SARJ wird anhand Extension .SRJ + ARJ-   }
{                                Format identifiziert                     }
{          2.50.04   11.03.99  - Compack-Sfxes werden erkannt             }
{          2.50.05   16.03.99  - LogiTech Compress wird identifiziert     }
{          2.50.06   20.03.99  - LHarc 1.13c-Sfxes werden erkannt         }
{          2.51.00   24.03.99  - Alle Funktionen LFN-fÑhig gemacht        }
{          2.51.01   31.03.99  - ARS-Sfx-Packer wird erkannt              }
{          2.51.02   02.04.99  - Format AKT wird identifiziert            }
{          2.51.03   05.04.99  - Formate Flash (FLH) und PC/3270 werden   }
{                                identifiziert                            }
{          2.51.04   11.04.99  - Formate NPack und PFT (Perfect Finishing }
{                                Touch) werden erkannt                    }
{          2.51.05   06.05.99  - Neues 4DOS 6.02-BATCOMP-Format wird erk. }
{          2.52.00   11.05.99  - Packer XTreme wird erkannt (scheint eine }
{                                RAX-Variante zu sein)                    }
{                              - Format SemOne wird identifiziert         }
{          2.52.01   12.05.99  - AKT32 wird erkannt                       }
{          2.52.02   18.05.99  - InstallIt 2.0x wird identifiziert        }
{          2.52.03   23.05.99  - Erkennung von MS Compress verbessert     }
{          2.52.04   27.05.99  - SemOne 0.5-Erkennung                     }
{          2.52.05   18.06.99  - Erkennung von PPMD                       }
{          2.53.00   02.07.99  - Neues ZIP-Format mit 'PK00PK' im         }
{                                Dateiheader wird erkannt                 }
{          2.53.01   13.07.99  - Format SWG (Sourceware Archival Group)   }
{                                wird identifiziert                       }
{          2.53.02   02.08.99  - Deutscher Winzip 32 Bit-Selfextractor    }
{                                wird erkannt (z.B. TGeb)                 }
{          2.54.00   08.08.99  - ARJ-Win32-Sfxes werden identifiziert     }
{                              - ARJ-Erkennung verbessert                 }
{                              - FIZ-Format wird erkannt                  }
{          2.55.00   13.08.99  - Wesentlich mehr RAR-32 Bit-Sfx-Formate   }
{                                werden identifiziert                     }
{          2.55.01   14.08.99  - RAR-32 Bit-Sfx 2.60b2 und RAR Linux      }
{                                2.60b2 werden erkannt                    }
{          2.56.00   18.09.99  - BA (M. Lundqvist) wird identifiziert     }
{                              - RAR-32 Bit-Sfx 2.60b4 wird identifiziert }
{                              - Unbekannte EXEs ohne angehÑngtes Archiv  }
{                                (Non-Sfxes) werden nicht mehr falsch     }
{                                identifiziert                            }
{                              - Kleinere Bugfixes bei LFN-Verarbeitung   }
{          2.56.01   21.09.99  - Bessere ARJ-DOS-Sfx-Erkennung (inklusive }
{                                Version 2.63)                            }
{          2.56.02   22.09.99  - RAR-32 Bit-Sfx 2.60b5 wird erkannt       }
{          2.56.03   29.09.99  - Format XPA32 (Jauming Tseng) wird erkannt}
{          2.56.04   02.10.99  - BA-Erkennung verbessert (einige Win-Sfxes}
{                                wurden fÑlschlicherweise als BA erkannt) }
{          2.57.00   14.11.99  - Format RK (Nachfolger von RKive) wird    }
{                                identifiziert                            }
{          2.57.01   09.01.00  - ARJ/2 2.70-Sfxes werden erkannt          }
{          2.58.00   21.02.00  - RedHat Linux RPM-Dateien werden erkannt  }
{          2.58.01   12.03.00  - PAK-Format wird sicherer von ARC/ARC+    }
{                                unterschieden                            }
{                              - Format DeepFreezer wird erkannt          }
{          2.58.02   16.03.00  - ZZip (Damien Debin) wird identifiziert   }
{          2.58.03   01.04.00  - ABComp 2.06 wird erkannt                 }
{          2.58.04   15.04.00  - DC 0.98b (Edgar Binder) wird erkannt     }
{          2.60.00   24.05.00  - ACE 2.0·1-Sfxe werden identifiziert      }
{          2.60.01   29.05.00  - TPac 1.7 von Tim Gordon wird erkannt     }
{          2.60.02   07.06.00  - ACE 2.0·2-Sfxe werden identifiziert      }
{          2.61.00   16.07.00  - Neue eMail-, WWW- und FTP-Adressen       }
{          2.61.01   24.07.00  - Bessere Erkennung neuerer ACE-, RAR- und }
{                                ARJ-Sfxe (alle Plattformen)              }
{          2.62.00   09.08.00  - Packer Ai (E.Ilya) wird identifiziert    }
{          2.62.01   26.08.00  - Ybs (Vadim Yoockin) wird erkannt         }
{                              - (Win)ACE 2.0b2-Sfxe werden identifiziert }
{          2.62.02   20.09.00  - Ai32 wird erkannt                        }
{          2.62.03   08.10.00  - (Win)ACE 2.0b3-Sfxe werden identifiziert }
{          2.63.00   18.10.00  - ACE 2.0b3-Sfx-Erkennung verbessert       }
{                              - Packer SBC (Sami MÑkinen) wird erkannt   }
{          2.63.01   29.10.00  - DitPack 1.0 wird identifiziert           }
{          2.64.00   08.12.00  - ACE-Sfxe 2.0b3 und 2.0b4 werden identi-  }
{                                fiziert (alle Plattformen)               }
{                              - Codeoptimierung der ACE-Sfx-Erkennungs-  }
{                                Funktion (Dank an Snow Panther)          }
{          2.64.01   12.12.00  - Codeoptimierung der ZIP- und RAR-Sfx-    }
{                                Erkennungs-Funktionen durch Snow Panther }
{                              - Viele neue ZIP-Sfxe (vor allem von Unix- }
{                                Plattformen) und einige ACE-Sfxe zugefÅgt}
{          2.64.02   31.12.00  - (Win-)ACE 2.0b5-Sfxe werden erkannt      }
{          2.65.00   11.01.01  - WinRAR und Rar/Linux 2.80b3 werden       }
{                                identifiziert                            }
{                              - ZZip 0.36b (inkl. Sfxe) wird erkannt     }
{          2.65.01   29.01.01  - PAR 2.00 Beta wird identifiziert         }
{          2.65.02   01.02.01  - (Win)ACE 2.0 Release-Sfxes werden erkannt}
{          2.65.03   13.02.01  - DMS (Amiga) wird identifiziert           }
{          2.65.04   17.02.01  - Weitere WinRAR- und WinACE-Sfxes werden  }
{                                identifiziert                            }
{          2.65.05   21.02.01  - Packer EPC wird erkannt                  }
{          2.65.06   10.03.01  - vectorsoft VSARC wird erkannt            }
{          2.65.07   29.03.01  - Weitere WinRAR-Sfxes werden identifiziert}
{          2.66.00   12.04.01  - Format RDMC wird erkannt                 }
{                              - Weitere ZIP-Sfxes werden identifiziert   }
{          2.66.01   04.05.01  - RDMC-Erkennung war unzuverlÑssig -       }
{                                entfernt                                 }
{          2.66.02   19.05.01  - Format PDZ wird erkannt                  }
{          2.66.03   04.06.01  - Bugfix in Installshield-EXE-Erkennung    }
{                                (Dank an Snow Panther)                   }
{          2.66.04   25.06.01  - "Package for the Web"-Format wird erkannt}
{                                (Dank an Snow Panther)                   }
{          2.66.05   07.07.01  - "NullSoft Installer"-Format wird erkannt }
{                                (Dank an Snow Panther)                   }
{          2.66.06   13.07.01  - InfoZIP-Sfx-Erkennung verbessert         }
{          2.66.07   24.07.01  - Neues ZIP-Sfx-Format (ZipGenie) wird     }
{                                (als ZIP) erkannt                        }
{          3.00.00   09.08.01  - Umfangreiche Bugfixes und énderungen,    }
{                                sowie Portierung auf FPC 1.0.4/32 Bit    }
{                                durch Ralph Roth, ROSE SWE               }
{                              - Weitere énderungen durch Snow Panther    }
{          3.10.00   14.08.01  - FPC-Win32-kompatibel                     }
{                              - DZip 2.6 (Nolan Pflug et al.) wird ident.}
{          3.10.01   28.08.01  - Sfx-Maker 2.x-Sfxe werden erkannt (als   }
{                                ZIPs)                                    }
{                              - WinACE 2.04- und WinRAR 2.90b3-Erkennung }
{          3.10.02   31.08.01  - Format 7z (7Zip 2.3b2) wird erkannt      }
{                              - Einige Code-Optimierungen                }
{          3.10.03   27.09.01  - ReDuq (Jacco Mintjes) wird identifiziert }
{          3.10.04   14.10.01  - Kleinere interne VerÑnderungen           }
{          3.10.05   30.10.01  - aPackage wird erkannt                    }
{          3.10.06   14.11.01  - Leider wurden immer noch viele Files     }
{                                fÑlschlicherweise als szip erkannt,      }
{                                Identifizierung Ñlterer szip-Versionen   }
{                                (vor 1.10) deshalb entfernt              }
{          3.11.00   16.01.02  - WinImage-Format .IMA hinzugefÅgt         }
{          3.11.01   02.03.02  - Verbesserte RAR 3.x-Sfx-Erkennung        }
{          3.12.00   08.03.02  - Schwerer Fehler der 2.11.01 beseitigt:   }
{                                Files mit langen Dateinamen wurden nicht }
{                                mehr gefunden                            }
{          3.12.01   14.03.02  - (Win-)RAR 3.0b4-Sfxe werden erkannt      }
{          3.12.02   27.03.02  - (Win-)RAR 3.0b5-Sfxe werden erkannt      }
{                              - BA-Erkennung (Typ 159) prÑzisiert        }
{          3.12.03   19.04.02  - (Win-)ACE-Sfx-Erkennung verbessert       }
{          3.12.04   26.05.02  - (Win-)RAR 3.00 Final-Sfxe werden erkannt }
{                              - Einige Code-Optimierungen                }
{          3.13.00   01.06.02  - Erkennung der Formate GCA (S. Tsuruta)   }
{                                und PPMN (Max Smirnov)                   }
{                              - WinRAR 3.00-Sfx-Erkennung verbessert     }
{          3.13.01   08.06.02  - SAPCAR wird identifiziert                }
{          3.13.02   29.06.02  - WinACE 2.2-Sfxe werden erkannt           }
{          3.14.00   17.10.02  - (Win)RAR 3.1b1-Sfxe werden erkannt       }
{                              - WinACE 2.3b1-Sfxe werden erkannt         }
{          3.14.01   26.10.02  - WinRAR 3.1b2-Sfxe werden erkannt         }
{          3.14.02   14.11.02  - WinRAR 3.1b3-Sfxe werden erkannt         }
{                              - WinACE 2.3b3-Sfxe werden erkannt         }
{          3.14.03   18.01.03  - WinRAR 3.11-Sfxe werden erkannt          }
{          3.14.04   25.01.03  - WinACE 2.5 Beta-Sfxe werden identifiziert}
{          3.14.05   15.02.03  - Format Compressia (Yaakov Gringeler) wird}
{                                erkannt                                  }
{          3.14.06   12.03.03  - WinRAR 3.20 Beta 1-Sfxe werden erkannt   }
{          3.14.07   12.06.03  - WinACE 2.5 RC2 und WinRAR 3.20 Final Sfxe}
{                                werden identifiziert                     }


{  Last changes:                                                          }
{          2.13                - First german-english version             }
{          2.14      02-23-97  - Format SKY is being recognized           }
{                    02-24-97  - Better RKive detection                   }
{          2.15      03-08-97  - ZAR was sometimes identified as TTComp   }
{                              - Format ARI is recognized - but only due  }
{                                to the file extension                    }
{                              - Format UFA is identified                 }
{                    03-09-97  - Microsoft's CAB (Windows 95) is being    }
{                                recognized                               }
{                    03-11-97  - Bugfix: some archives were only recog-   }
{                                nized, if their names were written in    }
{                                uppercase letters                        }
{                    03-12-97  - Recognition of FOXSQZ                    }
{                    03-16-97  - Recognition of AR7                       }
{                    03-18-97  - Idenfification of the Stirling Compressor}
{                    03-22-97  - Added PPMZ-recognition                   }
{          2.16      03-30-97  - Added MS Compress                        }
{                    04-02-97  - Identifies MP3 and ZET                   }
{          2.17      04-07-97  - Identifies XPack data and disk image     }
{                                files                                    }
{                    04-17-97  - Recognizes ARQ archives                  }
{          2.18      04-27-97  - Recognizes ACE archives                  }
{                    05-10-97  - Squash by D. Murk is being recognized    }
{          2.19      05-14-97  - Improved ACE-Sfx-recognition             }
{                              - Identification of packer Terse           }
{                    05-17-97  - Recognizes XPack single file data        }
{          2.20      05-21-97  - BS Archiver 1.6 (older version of BSA)   }
{                                is being identified (as BSN)             }
{                    05-24-97  - ACE 0.9c5 Sfx jr. is being recognized    }
{                              - Stuffit (Mac) is being identified        }
{                              - Improved PKZip Windows- and OS/2 sfx and }
{                                WinRAR install sfx recognition           }
{          2.21      05-25-97  - Because of problems of some older        }
{                                unpackers with multitaskers (eg. PKUnpak }
{                                and OS/2) IDPACKER opens archives in     }
{                                sharing mode (permit all)                }
{                    06-01-97  - PUCrunch is being identified             }
{                    06-04-97  - ACE 0.9d3 sfx is being recognized        }
{                    06-05-97  - BZip is being identified                 }
{          2.22      06-08-97  - ACE 0.9d4 sfx is being recognized        }
{                    06-09-97  - The following multiple volume archives   }
{                                are not more identified only from the    }
{                                file extension, but from the volume flag }
{                                in the archive header: ARJ, ARJ-Sfx, RAR,}
{                                RAR-Sfx, ACE                             }
{          2.23      06-18-97  - Recognition of ACE 0.9e3 sfx             }
{                    06-20-97  - Recognition of PKZip/2 2.50 sfx          }
{                    06-23-97  - Bugfix: when using wildcards in archive  }
{                                names sfxes were not recognized correctly}
{          2.24      07-19-97  - Recognition of UHarc 0.1.66              }
{                    07-23-97  - At the following archive formats it is   }
{                                detected, whether they are AV-secured    }
{                                or locked (through AV-Flag in header):   }
{                                ARJ, ARJ-Sfx, RAR, RAR-Sfx, ACE          }
{                    08-03-97  - Bugfix in function IsEXE(): the variable }
{                                FileMode was eventually not reset        }
{                                (Thanks to Ralph Roth)                   }
{                    08-04-97  - Format ABComp 2.04b is being recognized  }
{                    08-18-97  - Format CMP (AndrÇ Olejko) is identified  }
{                    08-20-97  - Smaller bugfixes                         }
{          2.25      08-24-97  - BZip2 is recognized                      }
{          2.26      08-25-97  - BS Archiver 1.9 (older version of BSA)   }
{                                is being identified (as BSN)             }
{                              - Recognizes LZOP (M.-F.-X.-J. Oberhumer)  }
{          2.27      08-26-97  - Better distinction ARC/PAK               }
{                                (Thanks to George Shadoff)               }
{          2.28      08-28-97  - Bugfix at ARJ-AV-recognition             }
{                              - Crude szip detection (only by one byte   }
{                                and extension .sz)                       }
{                    08-31-97  - WinZip sfxes are identified (as ZIPs)    }
{                    09-09-97  - Format Splint is being identified        }
{                    09-14-97  - Function IsEXE: DOS-EXEs may also start  }
{                                with 'ZM' instead of 'MZ' (thanks to     }
{                                Pierre Foucart)                          }
{          2.29      09-17-97  - Format TAR is recognized (only from file }
{                                extension .TAR)                          }
{                              - InstallShield format is identified       }
{          2.30      09-24-97  - Enhanced Codec-Detection                 }
{                              - Enhanced ZIP-Archiv-Detection            }
{                              - Enhanced Limit-Detection                 }
{                              - Format CARComp is recognized (only from  }
{                                file extension .CAR)                     }
{                    09-26-97  - Better detection of WinRAR (incl. 2.02)  }
{                    09-29-97  - LZS gets own archive type                }
{          2.31      10-11-97  - Also 32 bit WinZip sfxes are recognized  }
{                                (as ZIP)                                 }
{                    10-13-97  - Another Windows install sfx format (ZIP) }
{                                added                                    }
{                    10-14-97  - Simplified file access mode              }
{                    10-15-97  - Sometimes LHark archives were identified }
{                                as AIN                                   }
{          2.32      01-11-97  - Format BOA is being identified           }
{                              - InstallShield-Z-format is recognized     }
{                    08-11-97  - Formats ARG and Gather (GTH) are identif.}
{                              - RKive 1.9 is identified                  }
{          2.33      11-27-97  - Formats Pack Magic, Big Tree Software    }
{                                Archiver, ELI 5750 and QFC are identified}
{                    12-06-97  - PRO-PACK is identified                   }
{                              - WinZip32 recognition again improved      }
{                    01-01-98  - MSXiE by Mercury Soft Technology is      }
{                                being identified                         }
{                    01-17-98  - Another WinZip variant is identified     }
{          2.34      01-31-98  - Format RAX is being recognized           }
{                    03-01-98  - Format 777 (Win32) is being identified   }
{          2.35      04-12-98  - Formats LZS221 (Stac), HPA (Hungarian    }
{                                Pirate Alliance), Arhangel (George       }
{                                Lyapko), EXP1 (Bulat Ziganshin) and IMP  }
{                                are being identified                     }
{                    04-20-98  - BMF (compressed graphics format) is      }
{                                being identified                         }
{                    04-29-98  - NRV (demo by Markus Oberhumer) is being  }
{                                identified                               }
{                    04-30-98  - PAK 1.0a (Dmitry Dvoinikov) is recognized}
{                    05-07-98  - Squisch (Mike Albert) is identified      }
{          2.36      05-10-98  - Squisch (Mike Albert) is identified      }
{                              - PRO-PACK 2.14 (with other header) is     }
{                                recognized                               }
{                              - ParB (Win32 archiver) is being identified}
{                    05-10-98  - Identification of PAK 1.0a improved      }
{                    05-13-98  - Identification of ARX improved           }
{                    05-17-98  - WinRAR detection optimized               }
{          2.37      06-05-98  - Formats HIT (Bogdan Ureche) and SBX      }
{                                are being identified.                    }
{                    06-09-98  - Another WinZip sfx type added            }
{          2.40      06-14-98  - Improved szip detection (thanks to       }
{                                Michael Schindler for infos              }
{                              - Improved old LHarc and LARC sfx detection}
{          2.41.00   07-01-98  - Format NSK is identified                 }
{          2.41.01   07-03-98  - Another WinZip 32 bit sfx detected       }
{          2.41.02   07-11-98  - Format DST (Disintegrator 0.9b, Tommaso  }
{                                Gugli) is recognized                     }
{          2.41.03   07-12-98  - ASD (Tobias Svensson) is identified      }
{          2.42.00   08-03-98  - For better interpretation of the         }
{                                errorlevel unknown/invalid archives do   }
{                                not have type 0 anymore, but 251         }
{          2.42.01   08-12-98  - SZip bugfix                              }
{          2.42.02   08-17-98  - Better BTSPK identification              }
{          2.42.03   08-23-98  - InstallShield-CAB is recognized          }
{          2.42.04   09-02-98  - QFC 2.0 is identified                    }
{          2.42.05   09-10-98  - TOP4 and Batcomp (4DOS) are recognized   }
{          2.42.06   09-11-98  - Smaller bugfixes                         }
{          2.42.07   09-12-98  - Enhanced TOP4 and Batcomp identification }
{          2.42.08   10-14-98  - BlakHole (Win32) is recognized           }
{          2.43.00   12-02-98  - BIX (Igor Pavlov) is identified          }
{          2.43.01   01-15-99  - ChiefLZA is recognized                   }
{          2.50.00   02-14-99  - When incorporating LFN.PAS by Andreas    }
{                                Killer ($DEFINE LONGNAME) LFNs are       }
{                                supported under windows                  }
{          2.50.01   02-24-99  - Blink by D.T.S. is identified            }
{          2.50.02   03-01-99  - CAR by MylesHi! Software is recognized   }
{          2.50.03   03-07-99  - SARJ is recognized by extension .SRJ and }
{                                ARJ format                               }
{          2.50.04   03-11-99  - Compack sfxes are recognized             }
{          2.50.05   03-16-99  - LogiTech Compress is identified          }
{          2.50.06   03-20-99  - LHarc 1.13c sfxes are recognized         }
{          2.51.00   03-24-99  - Made all functions LFN capable           }
{          2.51.01   03-31-99  - ARS-Sfx-Packer is recognized             }
{          2.51.02   04-02-99  - Format AKT is identified                 }
{          2.51.03   04-05-99  - Formats Flash (FLH) and PC/3270 are      }
{                                identified                               }
{          2.51.04   04-11-99  - Formats NPack and PFT (Perfect Finishing }
{                                Touch) are recognized                    }
{          2.51.05   05-06-99  - New 4DOS 6.02-BATCOMP format is identif. }
{          2.52.00   05-11-99  - Packer XTreme is recognized (seems to be }
{                                a RAX variant)                           }
{                              - Format SemOne is identified              }
{          2.52.01   05-12-99  - AKT32 is recognized                      }
{          2.52.02   05-18-99  - InstallIt 2.0x is identified             }
{          2.52.03   05-25-99  - Improved MS Compress detection           }
{          2.52.04   05-27-99  - SemOne 0.5 recognition                   }
{          2.52.05   06-18-99  - Recognition of PPMD                      }
{          2.53.00   07-02-99  - New ZIP format with 'PK00PK' in the file }
{                                header is recognized                     }
{          2.53.01   07-13-99  - Format SWG (Sourceware Archival Group)   }
{                                is being identified                      }
{          2.53.02   08-02-99  - Added german Winzip 32 Bit selfextractor }
{          2.54.00   08-08-99  - ARJ Win32 sfxes are identified           }
{                              - Improved ARJ detection                   }
{                              - FIZ format is recognized                 }
{          2.55.00   08-13-99  - Added several RAR 32 bit-sfx formats     }
{          2.55.01   08-14-99  - RAR 32 bit sfx 2.60b2 and RAR Linux      }
{                                2.60b2 are identified                    }
{          2.56.00   09-18-99  - BA (M. Lundqvist) is recognized          }
{                              - RAR 32 bit sfx 2.60b4 is identified      }
{                              - No more false identifications of unknown }
{                                EXEs without archive data at the end     }
{                                (non-sfxes)                              }
{                              - Small bugfixes in LFN handling           }
{          2.56.01   09-21-99  - Better ARJ DOS sfx recognition (including}
{                                version 2.63)                            }
{          2.56.02   09-22-99  - RAR 32 bit sfx 2.60b5 is identified      }
{          2.56.03   09-29-99  - Format XPA32 (J. Tseng) is identified    }
{          2.56.04   10-02-99  - BA-Recognition improved (some Win-sfxes  }
{                                were falsely identified as BA)           }
{          2.57.00   11-14-99  - Format RK (successor of RKive) is being  }
{                                identified                               }
{          2.57.01   01-09-00  - ARJ/2 2.70 format is recognized          }
{          2.58.00   02-21-00  - RedHat Linux RPM files are identified    }
{          2.58.01   03-12-00  - PAK is better distinguished from ARC/ARC+}
{                              - Format DeepFreezer is recognized         }
{          2.58.02   03-16-00  - ZZip (Damien Debin) is being identified  }
{          2.58.03   04-01-00  - ABComp 2.06 is recognized                }
{          2.58.04   04-15-00  - DC 0.98b (Edgar Binder) is identified    }
{          2.60.00   05-24-00  - ACE 2.0·1 sfxes are recognized           }
{          2.60.01   05-29-00  - TPac 1.7 by Tim Gordon is identified     }
{          2.60.02   06-07-00  - ACE 2.0·1 sfxes are recognized           }
{          2.61.00   07-16-00  - New eMail, WWW and FTP addresses         }
{          2.61.01   07-24-00  - More reliable identification of newer    }
{                                ACE, RAR and ARJ sfxes (all platforms)   }
{          2.62.00   08-09-00  - Packer Ai (E.Ilya) is being identified   }
{          2.62.01   08-26-00  - Ybs (Vadim Yoockin) is identified        }
{                              - (Win)ACE 2.0b2 sfxes are recognized      }
{          2.62.02   09-20-00  - Ai32 is identified                       }
{          2.62.03   10-08-00  - (Win)ACE 2.0b3 sfxes are recognized      }
{          2.63.00   10-18-00  - ACE 2.0b3 sfx recognition improved       }
{                              - Packer SBC (Sami MÑkinen) is identified  }
{          2.63.01   10-19-00  - DitPack 1.0 is being identified          }
{          2.64.00   12-08-00  - ACE sfxes 2.0b3 and 2.0b4 are identified }
{                                (all platforms)                          }
{                              - Code optimization of ACE sfx recognition }
{                                function (thanks to Snow Panther)        }
{          2.64.01   12-12-00  - Code optimization of RAR and ZIP sfx     }
{                                recognition functions (by Snow Panther)  }
{                              - Added many new ZIP sfxes (primarily from }
{                                Unix platforms) and some ACE sfxes       }
{          2.64.02   12-31-00  - (Win-)ACE 2.0b5 sfxes are recognized     }
{          2.65.00   01-11-01  - WinRAR and Rar/Linux 2.80b3 are being    }
{                                identified                               }
{                              - ZZip 0.36b (incl. sfxes) is recognized   }
{          2.65.01   01-29-01  - PAR 2.00 beta is being identified        }
{          2.65.02   02-01-01  - (Win)ACE 2.0 Release sfxes are identified}
{          2.65.03   02-13-01  - DMS (Amiga) is recognized                }
{          2.65.04   02-17-01  - Some other WinRAR and WinACE sfxes are   }
{                                being identified                         }
{          2.65.05   02-21-01  - Packer EPC is recognized                 }
{          2.65.06   03-10-01  - vectorsoft VSARC is recognized           }
{          2.65.07   03-29-01  - More WinRAR sfxes are identified         }
{          2.66.00   04-12-01  - Format RDMC is recognized                }
{                              - More ZIP sfxes are identified            }
{          2.66.01   05-04-01  - RDMC recognition was unreliable - removed}
{          2.66.02   05-19-01  - Format PDZ is identified                 }
{          2.66.03   06-04-01  - Fixed a bug in Installshield EXE         }
{                                detection (thanks to Snow Panther)       }
{          2.66.04   06-25-01  - "Package for the Web" format is ident.   }
{                                (thanks to Snow Panther)                 }
{          2.66.05   07-07-01  - "NullSoft Installer" format is identified}
{                                (thanks to Snow Panther)                 }
{          2.66.06   07-13-01  - Improved InfoZIP sfx identification      }
{          2.66.07   07-24-01  - New ZIP sfx (ZipGenie) is recognized     }
{                                (as ZIP)                                 }
{          3.00.00   08-09-01  - Extensive bugfixes, changes and porting  }
{                                to FPC 1.0.4/32 Bit by Ralph Roth,       }
{                                ROSE SWE                                 }
{                              - Further changes by Snow Panther          }
{          3.10.00   08-14-01  - FPC win32 kompatible                     }
{                              - DZip 2.6 (Nolan Pflug et al.) is identif.}
{          3.10.01   08-28-01  - Sfx-Maker 2.x sfxes are recognized (as   }
{                                ZIPs)                                    }
{                              - WinACE 2.04- WinRAR 2.90b3 identification}
{          3.10.02   08-31-01  - Format 7z (7Zip 2.3b2) is recognized     }
{                              - Some code optimizations                  }
{          3.10.03   09-27-01  - ReDuq (Jacco Mintjes) is identified      }
{          3.10.04   10-14-01  - Some small internal changes              }
{          3.10.05   10-30-01  - aPackage is recognized                   }
{          3.10.06   11-14-01  - Unfortunately still many files were      }
{                                falsely recognized as szip, therefore the}
{                                identification of older szip versions    }
{                                (before 1.10) was dropped                }
{          3.11.00   01-16-02  - Added WinImage format .IMA               }
{          3.11.01   03-02-02  - Better RAR 3.x sfx recognition           }
{          3.12.00   03-08-02  - Severe bug in 2.11.01 eliminated: files  }
{                                with long names were not found any more  }
{          3.12.01   03-14-02  - (Win-)RAR 3.0b4 sfxes are identified     }
{          3.12.02   03-27-02  - (Win-)RAR 3.0b5-Sfxes are identified     }
{                              - Defined BA recognition (type 159)        }
{          3.12.03   04-19-02  - Improved (Win-)ACE sfx recognition       }
{          3.12.04   05-26-02  - (Win-)RAR 3.00 Final sfxes are identified}
{                              - Some code optimizations                  }
{          3.13.00   06-01-02  - Idenfification of the formats GCA        }
{                                (S. Tsuruta) and PPMN (Max Smirnov)      }
{                              - Improved WinRAR 3.00 sfx recognition     }
{          3.13.01   06-08-02  - Format SAPCAR is identified              }
{          3.13.02   06-29-02  - WinACE 2.2 sfxes are recognized          }
{          3.14.00   10-17-02  - (Win-)RAR 3.1 b1 sfxes are identified    }
{                              - WinACE 2.3 b1 sfxes are recognized       }
{          3.14.01   10-26-02  - WinRAR 3.1 b2 sfxes are identified       }
{          3.14.02   11-14-02  - WinRAR 3.1 b3 sfxes are identified       }
{                              - WinACE 2.3 b3 sfxes are recognized       }
{          3.14.03   01-18-03  - WinRAR 3.11 sfxes are identified         }
{          3.14.04   01-25-03  - WinACE 2.5 Beta sfxes are recognized     }
{          3.14.05   02-15-03  - Format Compressia (Yaakov Gringeler) is  }
{                                recognized                               }
{          3.14.06   03-12-03  - WinRAR 3.20 beta 1 sfxes are identified  }
{          3.14.07   06-12-03  - WinACE 2.5 RC2 and WinRAR 2.5 Final sfxes}
{                                are recognized                           }

Unit IDPacker;

INTERFACE

uses
  SysUtils, Classes;

CONST nIDPACKER=187+2;  { changed, rar - 0808-2001 }

      ARCType = 1;
      ZIPType = 2;
      ZOOType = 3;
      LZHType = 4;
      DWCType = 5;
      MDType = 6;
      LBRType = 7;
      ARJType = 8;
      HYPType = 9;
      UC2Type = 10;
      HAPType = 11;
      HAType = 12;
      HPKType = 13;
      SQZType = 14;
      RARType = 15;
      PAKType = 16;
      ARCPlusType = 17;
      LIMType = 18;
      BSNType = 19;
      PUTType = 20;
      SQWEZType = 21;
      CruPType = 22;
      CruJType = 23;
      CruLType = 24;
      CruZType = 25;
      CruHType = 26;
      LZEXEType = 27;
      PKLiteType = 28;
      DietType = 29;
      TinyProgType = 30;
      GIFType = 31;
      JFIFType = 32;
      JHSIType = 33;
      AINType = 34;
      AINEXEType = 35;
      SARType = 36;
      BS2Type = 37;
      GZIPType = 38;
      ACBType = 39;
      MARType = 40;
      CPZType = 41;
      JRCType = 42;
      JARType = 43;
      QType = 44;
      SofType = 45;
      CruType = 46;
      ARXType = 47;
      UCEXEType = 48;
      WWPType = 49;
      QARKType = 50;
      YACType = 51;
      X1Type = 52;
      CDCType = 53;
      AMGType = 54;
      NLIType = 55;
      PLLType = 56;
      TGZType = 57;
      WWDType = 58;
      CHZType = 59;
      PSAType = 60;
      ZARType = 61;
      LHKType = 62;
      PACType = 63;
      XFType = 64;
      KBOType = 65;
      NSQType = 66;
      DPAType = 67;
      TTCType = 68;
      WICType = 69;
      RKVType = 70;
      JRType = 71;
      ESPType = 72;
      ZPKType = 73;
      DRYType = 74;
      OWSType = 75;
      SkyType = 76;
      ARIType = 77;
      UfaType = 78;
      CABType = 79;
      FSqzType = 80;
      AR7Type = 81;
      TSCType = 82;
      PPMZType = 83;
      ExpType = 84;
      MP3Type = 85;
      ZetType = 86;
      XpaType = 87;
      XdiType = 88;
      ArqType = 89;
      AceType = 90;
      ArhType = 91;
      TerType = 92;
      XpdType = 93;
      SitType = 94;
      PucType = 95;
      BZipType = 96;
      UhaType = 97;
      AbcType = 98;
      CmpType = 99;
      BZip2Type = 100;
      LzoType = 101;
      SzipType = 102;
      SplType = 103;
      TarType = 104;
      IShType = 105;
      CaCType = 106;
      LzsType = 107;
      BoaType = 108;
      IShZType = 109;
      ArgType = 110;
      GthType = 111;
      PckType = 112;
      BtsType = 113;
      EliType = 114;
      QfcType = 115;
      RncType = 116;
      XieType = 117;
      RaxType = 118;
      _777Type = 119;
      StacType = 120;
      HpaType = 121;
      LgType = 122;
      Exp1Type = 123;
      ImpType = 124;
      BmfType = 125;
      NrvType = 126;
      PddType = 127;
      SqType = 128;
      ParType = 129;
      HitType = 130;
      SbxType = 131;
      NskType = 132;
      DstType = 133;
      AsdType = 134;
      IscType = 135;
      T4Type = 136;
      BtmType = 137;
      BhType = 138;
      BixType = 139;
      LzaType = 140;
      BliType = 141;
      CarType = 142;
      SArjType = 143;
      CpkType = 144;
      LgCType = 145;
      ArsType = 146;
      AktType = 147;
      FlhType = 148;
      PC3Type = 149;
      NpaType = 150;
      PftType = 151;
      XTType = 152;
      SemType = 153;
      A32Type = 154;
      IiType = 155;
      PpmType = 156;
      SwgType = 157;
      FizType = 158;
      BaType = 159;
      Xpa32Type = 160;
      RKType = 161;
      RpmType = 162;
      DfType = 163;
      ZZType = 164;
      DCType = 165;
      TpcType = 166;
      AiType = 167;
      YbsType = 168;
      Ai32Type = 169;
      SbcType = 170;
      DitType = 171;
      DmsType = 172;
      EpcType = 173;
      VsaType = 174;
      PdzType = 175;
      PfwType = 176;
      NullType = 177;
      WiseType = 178;
      DZType = 179;
      _7zType = 180;
      RdqType = 181;
      ApkType = 182;
      ImaType = 183;
      GcaType = 184;
      PmnType = 185;
      SapType = 186;
      CpaType = 187;

     Invalid = 251;
     FileNotFound = 255;

Var CrushPacked: Boolean;
     mv: Boolean = false;    (* Multiple volume file? *)
     av: Boolean = false;    (* AV-Envelope/Locked? *)
     NewIsc: Boolean = true; (* New InstallShield CAB (> 5.00.200)? *)
     IDStr: String = '';     (* Archive ID *)

TYPE
  PNamArray=Array[1..255] of String[20];
  PathStr = string;
  ExtStr = string[10];

VAR  PackerNames: ^PNamArray;

FUNCTION  ArchiveType(ArcName: PathStr): Byte;
FUNCTION  ExeSize(FName: PathStr): LongInt;
FUNCTION  IsExe(FName: PathStr): Boolean;
PROCEDURE AssignPackerNames;
PROCEDURE DisposePackerNames;

IMPLEMENTATION

TYPE FileStr = {String[12];} PathStr;

VAR Size  : LongInt;
    f     : File;
    s     : String;
    IsEx: Boolean = false;
(* Packernamen den Errorlevels zuordnen.
   Assign packer names to errorlevels. *)

PROCEDURE AssignPackerNames;
 BEGIN
  New(PackerNames);
  FillChar(PackerNames^,SizeOf(PackerNames^),0);
  PackerNames^[  1] := 'ARC';
  PackerNames^[  2] := 'ZIP';
  PackerNames^[  3] := 'ZOO';
  PackerNames^[  4] := 'LZH';
  PackerNames^[  5] := 'DWC';
  PackerNames^[  6] := 'MDCD';
  PackerNames^[  7] := 'LBR';
  PackerNames^[  8] := 'ARJ';
  PackerNames^[  9] := 'HYP';
  PackerNames^[ 10] := 'UC2';
  PackerNames^[ 11] := 'HAP';
  PackerNames^[ 12] := 'HA';
  PackerNames^[ 13] := 'HPack';
  PackerNames^[ 14] := 'SQZ (Squeeze It)';
  PackerNames^[ 15] := 'RAR';
  PackerNames^[ 16] := 'PAK';
  PackerNames^[ 17] := 'ARC+';
  PackerNames^[ 18] := 'LIM';
  PackerNames^[ 19] := 'BSN (BSA/PTS-DOS)';
  PackerNames^[ 20] := 'PUT';
  PackerNames^[ 21] := 'SQWEZ';
  PackerNames^[ 22] := 'Crush/ZIP';
  PackerNames^[ 23] := 'Crush/ARJ';
  PackerNames^[ 24] := 'Crush/LZH';
  PackerNames^[ 25] := 'Crush/ZOO';
  PackerNames^[ 26] := 'Crush/HA';
  PackerNames^[ 27] := 'LZExe';
  PackerNames^[ 28] := 'PKLite';
  PackerNames^[ 29] := 'Diet';
  PackerNames^[ 30] := 'TinyProg';
  PackerNames^[ 31] := 'GIF';
  PackerNames^[ 32] := 'JPG (JFIF)';
  PackerNames^[ 33] := 'JPG (HSI)';
  PackerNames^[ 34] := 'AIN';
  PackerNames^[ 35] := 'AINEXE';
  PackerNames^[ 36] := 'SAR';
  PackerNames^[ 37] := 'BS2/BSArc';
  PackerNames^[ 38] := 'GZIP/Comp 4.3';
  PackerNames^[ 39] := 'ACB';
  PackerNames^[ 40] := 'MAR';
  PackerNames^[ 41] := 'CPZ (CPShrink)';
  PackerNames^[ 42] := 'JRC';
  PackerNames^[ 43] := 'JArcs';
  PackerNames^[ 44] := 'Quantum';
  PackerNames^[ 45] := 'ReSOF';
  {$IFNDEF ENGLISH}
  PackerNames^[ 46] := 'Crush/ungepackt';
  {$ELSE}
  PackerNames^[ 46] := 'Crush/uncomp.';
  {$ENDIF}
  PackerNames^[ 47] := 'ARX';
  PackerNames^[ 48] := 'UCEXE';
  PackerNames^[ 49] := 'WWPack';
  PackerNames^[ 50] := 'QuArk';
  PackerNames^[ 51] := 'YAC';
  PackerNames^[ 52] := 'X1';
  PackerNames^[ 53] := 'Codec';
  PackerNames^[ 54] := 'AMGC';
  PackerNames^[ 55] := 'NuLIB';
  PackerNames^[ 56] := 'PAKLeo (PLL)';
  PackerNames^[ 57] := 'TGZ';
  {$IFNDEF ENGLISH}
  PackerNames^[ 58] := 'WWPack-Datendatei';
  {$ELSE}
  PackerNames^[ 58] := 'WWPack data file';
  {$ENDIF}
  PackerNames^[ 59] := 'ChArc';
  PackerNames^[ 60] := 'PSA';
  PackerNames^[ 61] := 'ZAR';
  PackerNames^[ 62] := 'LHark';
  PackerNames^[ 63] := 'CrossePAC';
  PackerNames^[ 64] := 'Freeze';
  PackerNames^[ 65] := 'KBoom';
  PackerNames^[ 66] := 'NSQ';
  PackerNames^[ 67] := 'DPA';
  PackerNames^[ 68] := 'TTComp';
  PackerNames^[ 69] := 'WIC (Fake!)';
  PackerNames^[ 70] := 'RKive';
  PackerNames^[ 71] := 'JAR';
  PackerNames^[ 72] := 'ESP';
  PackerNames^[ 73] := 'ZPack';
  PackerNames^[ 74] := 'DRY';
  PackerNames^[ 75] := 'OWS (Fake!)';
  PackerNames^[ 76] := 'SKY';
  PackerNames^[ 77] := 'ARI';
  PackerNames^[ 78] := 'UFA';
  PackerNames^[ 79] := 'Microsoft CAB';
  PackerNames^[ 80] := 'FOXSQZ';
  PackerNames^[ 81] := 'AR7';
  PackerNames^[ 82] := 'TSComp';
  PackerNames^[ 83] := 'PPMZ';
  PackerNames^[ 84] := 'MS Compress';
  PackerNames^[ 85] := 'MP3 (Marco Czudej)';
  PackerNames^[ 86] := 'ZET';
  PackerNames^[ 87] := 'XPack Data';
  PackerNames^[ 88] := 'XPack Diskimage';
  PackerNames^[ 89] := 'ARQ';
  PackerNames^[ 90] := 'ACE';
  PackerNames^[ 91] := 'Squash';
  PackerNames^[ 92] := 'Terse';
  PackerNames^[ 93] := 'XPack single data';
  PackerNames^[ 94] := 'Stuffit (Mac)';
  PackerNames^[ 95] := 'PUCrunch';
  PackerNames^[ 96] := 'BZip';
  PackerNames^[ 97] := 'UHarc';
  PackerNames^[ 98] := 'ABComp';
  PackerNames^[ 99] := 'CMP (AndrÇ Olejko)';
  PackerNames^[100] := 'BZip2';
  PackerNames^[101] := 'LZO';
  PackerNames^[102] := 'szip';
  PackerNames^[103] := 'Splint';
  PackerNames^[104] := 'TAR';
  PackerNames^[105] := 'InstallShield';
  PackerNames^[106] := 'CARComp';
  PackerNames^[107] := 'LZS';
  PackerNames^[108] := 'BOA';
  PackerNames^[109] := 'InstallShield Z';
  PackerNames^[110] := 'ARG';
  PackerNames^[111] := 'Gather';
  PackerNames^[112] := 'Pack Magic';
  PackerNames^[113] := 'BTS';
  PackerNames^[114] := 'ELI 5750';
  PackerNames^[115] := 'QFC';
  PackerNames^[116] := 'PRO-PACK';
  PackerNames^[117] := 'MSXiE';
  PackerNames^[118] := 'RAX';
  PackerNames^[119] := '777';
  PackerNames^[120] := 'LZS221';
  PackerNames^[121] := 'HPA';
  PackerNames^[122] := 'Arhangel';
  PackerNames^[123] := 'EXP1';
  PackerNames^[124] := 'IMP';
  PackerNames^[125] := 'BMF';
  PackerNames^[126] := 'NRV';
  PackerNames^[127] := 'oPAQue';
  PackerNames^[128] := 'Squish (Mike Albert)';
  PackerNames^[129] := 'Par';
  PackerNames^[130] := 'HIT (Bogdan Ureche)';
  PackerNames^[131] := 'SBX';
  PackerNames^[132] := 'NaShrink';
  PackerNames^[133] := 'Disintegrator';
  PackerNames^[134] := 'ASD';
  PackerNames^[135] := 'InstallShield CAB';
  PackerNames^[136] := 'TOP4';
  PackerNames^[137] := 'BatComp (4DOS)';
  PackerNames^[138] := 'BlakHole';
  PackerNames^[139] := 'BIX (Igor Pavlov)';
  PackerNames^[140] := 'ChiefLZA';
  PackerNames^[141] := 'Blink (D.T.S.)';
  PackerNames^[142] := 'CAR (MylesHi!)';
  PackerNames^[143] := 'SARJ';
  PackerNames^[144] := 'Compack Sfx';
  PackerNames^[145] := 'Logitech Compress';
  PackerNames^[146] := 'ARS-Sfx';
  PackerNames^[147] := 'AKT';
  PackerNames^[148] := 'Flash';
  PackerNames^[149] := 'PC/3270';
  PackerNames^[150] := 'NPack';
  PackerNames^[151] := 'PFT';
  PackerNames^[152] := 'Xtreme';
  PackerNames^[153] := 'SemOne';
  PackerNames^[154] := 'AKT32';
  PackerNames^[155] := 'InstallIt';
  PackerNames^[156] := 'PPMD';
  PackerNames^[157] := 'Swag';
  PackerNames^[158] := 'FIZ';
  PackerNames^[159] := 'BA (M. Lundqvist)';
  PackerNames^[160] := 'XPA32 (J. Tseng)';
  PackerNames^[161] := 'RK (M.Taylor)';
  PackerNames^[162] := 'RPM';
  PackerNames^[163] := 'DeepFreezer';
  PackerNames^[164] := 'ZZip (Damien Debin)';
  PackerNames^[165] := 'DC (Edgar Binder)';
  PackerNames^[166] := 'TPac (Tim Gordon)';
  PackerNames^[167] := 'Ai (E.Ilya)';
  PackerNames^[168] := 'Ybs (Vadim Yoockin)';
  PackerNames^[169] := 'Ai32 (E.Ilya)';
  PackerNames^[170] := 'SBC (Sami MÑkinen)';
  PackerNames^[171] := 'DitPack';
  PackerNames^[172] := 'DMS';
  PackerNames^[173] := 'EPC';
  PackerNames^[174] := 'VSARC';
  PackerNames^[175] := 'PDZ';
  PackerNames^[176] := 'Package for the Web';
  PackerNames^[177] := 'NullSoft Installer';
  PackerNames^[178] := 'Wise Installer';
  PackerNames^[179] := 'DZip (Nolan Pflug)';
  PackerNames^[180] := '7z';
  PackerNames^[181] := 'ReDuq (J. Mintjes)';
  PackerNames^[182] := 'aPackage';
  PackerNames^[183] := 'WinImage';
  PackerNames^[184] := 'GCA';
  PackerNames^[185] := 'PPMN (Max Smirnov)';
  PackerNames^[186] := 'SAPCAR';
  PackerNames^[187] := 'Compressia';
  {$IFNDEF ENGLISH}
  PackerNames^[Invalid] := 'unbekannt';
  PackerNames^[FileNotFound] := 'Datei nicht gefunden';
  {$ELSE}
  PackerNames^[Invalid] := 'unknown';
  PackerNames^[FileNotFound] := 'File not found';
  {$ENDIF}
 END;

(* Packernamen-Speicher wieder freigeben.
   Release heap of packer names.          *)

PROCEDURE DisposePackerNames;
 BEGIN
  Dispose(PackerNames);
 END;

(* Die FUNKTION CapStr wandelt einen String in Gro·buchstaben um, wobei die
  deutschen Umlaute berÅcksichtigt werden. Beispiel:

  The FUNCTION CapStr changes a string to uppercase, German "Umlauts" are
  being taken into consideration. Example:

             Name := CapStr('DÅsseldorf'); (ergibt 'DöSSELDORF') *)

Function CapStr(St: String): String;

 Var
    i         : Byte;

 Begin
   For i := 1 To Length(St) Do          { changed rar, 0808-2001 }
     Begin
       Case St[i] Of
         'Ñ' : St[i] := 'é';
         'î' : St[i] := 'ô';
         'Å' : St[i] := 'ö';
         Else St[i] := Upcase(St[i]);
       End;
     End;
   CapStr := St;
 End;

(* Die Funktion Strip kÅrzt einen String um ein angegebenes Zeichen.
  The function Strip deletes a given character from a string. *)

Function Strip(L,C: Char; S: String): String;
(* L = links, rechts, beide Enden oder alle Vorkommen.
  L = left, right, both ends or all occurances. *)

Var I: Byte;
Begin
   Case Upcase(L) Of
     'L' :
           Begin       {Left}
             While (S[1] = C) and (length(S) > 0) Do
                   Delete(S,1,1);
           End;
     'R' :
           Begin       {Right}
             While (S[length(S)] = C) and (length(S) > 0) Do
                                   Delete(S,length(S),1);
           End;
     'B' :
           Begin       {Both left and right}
             While (S[1] = C) and (length(S) > 0) Do
                   Delete(S,1,1);
             While (S[length(S)] = C) and (length(S) > 0)  Do
                                   Delete(S,length(S),1);
           End;
     'A' :
           Begin       {All}
             I := 1;
             Repeat
                  If (S[I] = C) And (length(S) > 0) Then
                     Delete(S,I,1)
                  Else
                     Inc(I);
             Until (I > length(S)) Or (S = '');
           End;
   End;
   Strip := S;
End; {Function Strip}

(* Existiert die Datei?
  Does the file exist? *)

Function Exist(Filename: PathStr): Boolean;

 Var f    : File;
    FMode : Byte;
    IO    : Word;
 Begin
   If FileName='' Then Exist := false
   Else
     Begin
       FMode := FileMode;
       FileMode := 0;
   {$IFDEF LONGNAME}
       Filename := Strip('B','"',Filename);
   {$ENDIF}
       Assign(f,Filename);
       Reset(f);
       IO := IOResult;
       If IO=0 Then
         Begin
           Exist := true;
           Close(f);
         End
       Else Exist := false;
       FileMode := FMode;
     End;
 End;

(* Alte Assembler-Variante von Exist; nicht LFN-fÑhig.

FUNCTION Exist(Filename: String): Boolean; Assembler;
 VAR ZStr: String;
 ASM
 PUSH DS
 LDS  SI, Filename        { make ASCIIZ }
 MOV  AX, SS
 MOV  ES, AX
 LEA  DI, ZStr
 MOV  DX, DI
 XOR  CH, CH
 MOV  CL, BYTE PTR [SI]
 INC  SI
 REP  MOVSB
 MOV  BYTE PTR ES: [DI], 0
                   MOV  DS, AX
                   MOV  AX, 4371h           { get file attributes }
                   XOR  BL, BL
                   INT  21h
                   MOV  AL, FALSE
                   JC   @Exit               { fail? }
                   AND  CX, 24
                   JNZ  @Exit
                   INC  AL
                   @Exit: POP DS
 End;
*)

(* LastPos gibt die Stelle des letzten Vorkommens eines Zeichens im String
  zurÅck.

  LastPos returns the last occurance of a char in a string. *)

Function LastPos(c:Char; Str: String): Byte;

 Var i: Byte;
 Begin
   i := Length(Str)+1;
   Repeat
     Dec(i);
   Until (i=0) Or (Str[i]=c);
   LastPos := i;
 End;

(* Die FUNKTION GetFName extrahiert aus einem ihr Åbergebenen Pfadnamen (Typ
  PathStr) den eigentlichen Dateinamen (Typ FileStr ( String[12]), Wildcards
  sind nicht erlaubt. Beispiel:

  The FUNCTION GetFName extracts a filename from a complete pathname.
  Wildcards are not allowed. Example:

  s := GetFName('C:\DOS\FORMAT.COM'); liefert s = 'FORMAT.COM' *)

Function GetFName(Datei: PathStr): FileStr;

 Var k                       : Byte;
    s                        : PathStr;
 Begin
   s := '';
   k := Length(Datei);
   While ((Datei[k] <> '\') and (Datei[k] <> ':') and (k > 0)) Do
   Begin
     s := Datei[k]+s;
     Dec(k);
   End;
   GetFName := s;
 End;

(* Die FUNKTION GetExt extrahiert aus einem ihr Åbergebenen Pfadnamen (Typ
  PathStr) die Dateiextension (Typ ExtStr ( String[4]), Wildcards sind
  nicht erlaubt. Beispiel:

  The FUNCTION GetExt extracts the file extension from a complete pathname.
  Wildcards are not allowed. Example:

  s := GetExt('C:\DOS\FORMAT.COM'); liefert s = '.COM' *)

Function GetExt(Datei: PathStr): ExtStr;

 Var s : PathStr;
    i : Byte;
 Begin
   s := GetFName(Datei);
   i := LastPos('.',s);
   If i <> 0 Then
     Begin
       Delete(s,1,i-1);
       GetExt := s;
     End
   Else GetExt := '';
 End;

(* Die FUNKTION FSize ermittelt die Dateigrî·e in Bytes und gibt -1 zurÅck,
  wenn die Datei nicht existiert.

  The FUNCTION FSize detects the filesize in bytes and returns -1, if
  the file does not exist. *)

Function FSize(Filename: PathStr): LongInt;

 Var f : File Of Byte;
    IO: Word;
    { FMode: Byte; }
 Begin
 { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
 {$IFDEF LONGNAME}
   Filename := Strip('B','"',Filename);
 {$ENDIF}
   Assign(f,Filename);
   Reset(f);
   IO := IOResult;
   If (IO=0) Or (IO=100) Then
     Begin
       FSize := FileSize(f);
       Close(f);
     End
   Else FSize := -1;
 { FileMode := FMode; }
 End;

(* Die FUNKTION EXESize ermittelt die Grî·e einer EXE-Datei aus ihrem Header.

  The FUNCTION EXESize detects the size of an EXE-file from its header. *)

Function ExeSize(FName: PathStr): LongInt;

 Var f           : File Of Word;
     S,R,IO      : Word;
     Size,Rest   : LongInt;
     { FMode       : Byte; }
 Begin
  { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
  {$IFDEF LONGNAME}
   FName := Strip('B','"',FName);
  {$ENDIF}
   Assign(f,FName);
   Reset(f);
   IO := IOResult;
   If (IO=0) Or (IO=100) Then
     Begin
       Seek(f,1);
       Read(f,R);
       Read(f,S);
       Close(f);
       Size := LongInt(S);
       Rest := LongInt(R);
       ExeSize := ((Size-1) Mod 512) shl 9 + Rest;
     End
   Else ExeSize := -1;
   { FileMode := FMode; }
 End;

(* Handelt es sich bei der Datei um eine EXE- oder COM-Datei?
  Is the file an EXE or COM file? *)

Function IsExe(FName: PathStr): Boolean;

 Var f: File Of Word;
    { FMode: Byte; }
    MZ,IO: Word;
 Begin
 { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
 {$IFDEF LONGNAME}
   FName := Strip('B','"',FName);
 {$ENDIF}
   Assign(f,FName);
   Reset(f);
   IO := IOResult;
   If (IO=0) Or (IO=100) Then
     Begin
       Read(f,MZ);
       Close(f);
       IsExe := (((MZ=$5A4D) Or (MZ=$4D5A)) And (ExeSize(FName)>0)) or (GetExt(CapStr(FName))='.COM');
     End
   Else IsExe := false;
 { FileMode := FMode; }
 End;

(* Die FUNKTION Bit ergibt den Zustand von Bit b der Zahl n und dient zur
  Abfrage Bit-codierter Statusinformationen.

  The function Bit returns if bit b of the number n is set. *)

Function Bit(b: Byte; n: Word): Boolean;
 Begin
   b := b And 15;
   Bit := ((n SHR b) And 1) = 1;
 End;

(* Handelt es sich um ein Multiple volume-Archiv (gÑngigste Packer)?
  Is the file a multiple volume archive (only most common packers)? *)

Function VolumeFlag(c: Char; Packer: Byte): Boolean;

 Var VFlag: Byte;
 Begin
   VolumeFlag := false;
   VFlag := Byte(c);
   Case Packer Of
     ARJType: If Bit(2,VFlag) Then VolumeFlag := true;
     RARType: If Bit(0,VFlag) Then VolumeFlag := true;
     ACEType: If Bit(3,VFlag) Then VolumeFlag := true;
   End;
 End;

(* Hat das Archiv einen "Security envelope" (gÑngigste Packer)?
  Has the archive a security envelope (only most common packers)? *)

Function AVFlag(c: Char; Packer: Byte): Boolean;

 Var AFlag: Byte;
 Begin
   AVFlag := false;
   AFlag := Byte(c);
   Case Packer Of
     ARJType: If Bit(6,AFlag) Or Bit(1,AFlag) Then AVFlag := true;
     (* Bit 1 = alter Security Envelope *)
     RARType: If Bit(5,AFlag) Or Bit(2,AFlag) Then AVFlag := true; (* Bit 2 = locked *)
     ACEType: If Bit(4,AFlag) Or Bit(6,AFlag) Then AVFlag := true; (* Bit 6 = locked *)
   End;
 End;

(* Suche nach ID-String an bestimmter Dateiposition.
   Search for id string at a fixed file offset.

   Funktion von Snow Panther, danke!
   Function by Snow Panther, thanks! *)

FUNCTION CheckAnySign(fpos:Longint; NeedId:String; SSize:Byte): Boolean;
 Begin
  CheckAnySign := false;
  If fpos+SSize <= Size then
   begin
    Seek(f,fpos);
    BlockRead(f,s[1],SSize);
    SetLength(s, SSize);
    If s=NeedId then CheckAnySign := true;
   end;
 End;

(* Ist die Datei mit AINEXE gepackt?
  Is the file AINEXE-packed? *)

Function AINEXEPacked(ArcName: PathStr): Boolean;

 Var f: File;
    s: String[35];
    { FMode: Byte; }
 Begin
   AINEXEPacked := false;
   s := '';
 { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
 {$IFDEF LONGNAME}
   ArcName := Strip('B','"',ArcName);
 {$ENDIF}
   Assign(f,ArcName);
   Reset(f,1);
   Size := FileSize(f);
   If Size>=Length(s) Then
     Begin
       BlockRead(f,s[1],SizeOf(s)-1);
       s[0] := #35;
       AINEXEPacked := Pos('AIN',s)=33;
     End;
   Close(f);
 { FileMode := FMode; }
 End;

(* Ist die Datei mit UCEXE gepackt?
  Is the file UCEXE-packed? *)

Function UCEXEPacked(ArcName: PathStr): Boolean;

 Var f: File;
    s: String[32];
    { FMode: Byte; }
 Begin
   UCEXEPacked := false;
   s := '';
 { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
 {$IFDEF LONGNAME}
   ArcName := Strip('B','"',ArcName);
 {$ENDIF}
   Assign(f,ArcName);
   Reset(f,1);
   Size := FileSize(f);
   If Size>=Length(s) Then
     Begin
       BlockRead(f,s[1],SizeOf(s)-1);
       s[0] := #32;
       UCEXEPacked := Pos('UC2X',s)=29;
     End;
   Close(f);
 { FileMode := FMode; }
 End;

(* Ist die Datei ein ARJ-Win32-Sfx?
  Is the file an ARJ Win32 sfx? *)

Function ArjWinSfxPacked(ArcName: PathStr): Boolean;

 Var Sfx: Boolean;
    { FMode: Byte; }
 Begin
   ArjWinSfxPacked := false;
   s := '';
 { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
 {$IFDEF LONGNAME}
   ArcName := Strip('B','"',ArcName);
 {$ENDIF}
   Assign(f,ArcName);
   Reset(f,1);
   Size := FileSize(f);
   If Size>=Length(s) Then
     Begin
       Seek(f,900);
       BlockRead(f,s[1],6);
       SetLength(s, 6);
       Sfx := CapStr(s)='ARJSFX';
       ArjWinSfxPacked := Sfx;
       If Sfx Then
         Begin
           Seek(f,15006);
           BlockRead(f, IDStr[1], SizeOf(IDStr) - 1);
           SetLength(IDStr, 255);
         End;
     End;
   Close(f);
 { FileMode := FMode; }
 End;

(* Ist die Datei ein ARJ-DOS- oder OS/2-Sfx?
   Is the file an ARJ DOS or OS/2 sfx? *)

Function ArjDOSSfxPacked(ArcName: PathStr): Boolean;

 Var Sfx: Boolean;
    { FMode: Byte; }
 Begin
   ArjDOSSfxPacked := false;
   s := '';
 { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
 {$IFDEF LONGNAME}
   ArcName := Strip('B','"',ArcName);
 {$ENDIF}
   Assign(f,ArcName);
   Reset(f,1);
   Size := FileSize(f);
   If Size>=Length(s) Then
     Begin
       Seek(f,225);
       BlockRead(f,s[1],6);
       SetLength(s, 6);
       Sfx := CapStr(s)='ARJSFX';
       ArjDosSfxPacked := Sfx;
       If Not Sfx Then
         Begin
           Seek(f,567);
           BlockRead(f,s[1],6);
           SetLength(s, 6);
           Sfx := CapStr(s)='ARJSFX';
           ArjDosSfxPacked := Sfx;
           If Not Sfx Then
             Begin
               Seek(f,663);
               BlockRead(f,s[1],6);
               SetLength(s, 6);
               Sfx := CapStr(s)='ARJSFX';
               ArjDosSfxPacked := Sfx;
               If Not Sfx Then
                 Begin
                   Seek(f,664);
                   BlockRead(f,s[1],6);
                   SetLength(s, 6);
                   Sfx := CapStr(s)='ARJSFX';
                   ArjDosSfxPacked := Sfx;
                   If Not Sfx Then
                     Begin
                       Seek(f,900);
                       BlockRead(f,s[1],6);
                       SetLength(s, 6);
                       Sfx := CapStr(s)='ARJSFX';
                       ArjDosSfxPacked := Sfx;
                       If Not Sfx Then
                         Begin
                           Seek(f,208);
                           BlockRead(f,s[1],6);
                           SetLength(s, 6);
                           Sfx := CapStr(s)='ARJSFX';
                           ArjDosSfxPacked := Sfx;
                           If Not Sfx Then
                             Begin
                               Seek(f,262);
                               BlockRead(f,s[1],6);
                               SetLength(s, 6);
                               Sfx := CapStr(s)='ARJSFX';
                               ArjDosSfxPacked := Sfx;
                             End;
                           If Not Sfx Then
                             Begin
                               Seek(f,85);
                               BlockRead(f,s[1],6);
                               SetLength(s, 6);
                               Sfx := CapStr(s)='ARJSFX';
                               ArjDosSfxPacked := Sfx;
                             End;
                         End;
                     End;
                 End;
             End;
         End;
     End;
   Close(f);
 { FileMode := FMode; }
 End;

(* Ist die Datei ein ACE-DOS-, Win- oder OS/2-Sfx?
   Is the file an ACE DOS, Win or OS/2 sfx?

   Funktion optimiert von Snow Panther, danke!
   Function optimized by Snow Panther, thanks! *)

Function ACESfxPacked(ArcName: PathStr): Boolean;

 Label THE_END;

   { Var FMode : Byte; }

Begin
  ACESfxPacked := false;
  s := '';
 { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
 {$IFDEF LONGNAME}
  ArcName := Strip('B','"',ArcName);
 {$ENDIF}
  Assign(f,ArcName);
  Reset(f,1);
  Size := FileSize(f)-5; {5 = length}
  If CheckAnySign(7507,'**ACE',5)   Then goto THE_END;
  If CheckAnySign(7607,'**ACE',5)   Then goto THE_END;
  If CheckAnySign(14037,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(15050,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(15607,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(15807,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(16807,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(21807,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(21907,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(22007,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(22607,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(40967,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(42503,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(43015,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(44039,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(44551,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(57162,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(57174,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(57274,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(57290,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(57646,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(57746,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(57770,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(58609,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(58610,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(58756,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(58837,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(58848,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(58850,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(59122,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(59360,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(61110,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(61134,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(61146,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(61150,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(61170,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(61258,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(61270,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(61341,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(61409,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(61580,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(62194,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(62465,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(62671,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(62988,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(63031,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(63110,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(63193,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(63256,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(63568,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(63739,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(63840,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(63883,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(63960,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(64045,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(64099,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(64116,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(64142,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(64218,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(64304,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(64374,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(64635,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(65284,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(66798,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(67070,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(67114,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(67192,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(67275,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(67310,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(67319,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(67338,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(68261,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(68614,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(68739,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(71192,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(71714,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(73505,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(77619,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(77763,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(90642,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(90755,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(91010,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(91865,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(92531,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(92996,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(92997,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(95239,'**ACE',5)  Then goto THE_END;
  If CheckAnySign(101045,'**ACE',5) Then goto THE_END;
  If CheckAnySign(102801,'**ACE',5) Then goto THE_END;
  If CheckAnySign(102849,'**ACE',5) Then goto THE_END;
  If CheckAnySign(103010,'**ACE',5) Then goto THE_END;
  If CheckAnySign(103924,'**ACE',5) Then goto THE_END;
  If CheckAnySign(104537,'**ACE',5) Then goto THE_END;
  If CheckAnySign(106488,'**ACE',5) Then goto THE_END;
  If CheckAnySign(145765,'**ACE',5) Then goto THE_END;
  If CheckAnySign(147061,'**ACE',5) Then goto THE_END;
  If CheckAnySign(148780,'**ACE',5) Then goto THE_END;
  If CheckAnySign(148820,'**ACE',5) Then goto THE_END;
  If CheckAnySign(149080,'**ACE',5) Then goto THE_END;
  If CheckAnySign(152001,'**ACE',5) Then goto THE_END;
  If CheckAnySign(152881,'**ACE',5) Then goto THE_END;
  If CheckAnySign(152887,'**ACE',5) Then goto THE_END;
  If CheckAnySign(152982,'**ACE',5) Then goto THE_END;
  Close(f);
  Exit;

  THE_END:

  ACESfxPacked := true;
  Close(f);

 { FileMode := FMode; }
End;

(* Ist die Datei ein ZIP-DOS-, Win- oder OS/2-Sfx?
   Is the file a ZIP DOS, Win or OS/2 sfx?

   Funktion optimiert von Snow Panther, danke!
   Function optimized by Snow Panther, thanks! *)

Function PKWinOS2SfxPacked(ArcName: PathStr): Boolean;

Label THE_END;

    { Var FMode: Byte; }

 Begin
   PKWinOS2SfxPacked := false;
   s := '';
  { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
  {$IFDEF LONGNAME}
   ArcName := Strip('B','"',ArcName);
  {$ENDIF}
   Assign(f,ArcName);
   Reset(f,1);
   Size := FileSize(f);
   If CheckAnySign(50,'PKWARE Inc. All Rights Reserved',31) Then goto THE_END;
   If CheckAnySign(126,'WinZip Self-Extractor',21) Then goto THE_END;
   If CheckAnySign(464,'GWinZip',7) Then goto THE_END;
   If CheckAnySign(512,'GWinZip',7) Then goto THE_END;
   If CheckAnySign(526,'PKSFX',5) Then goto THE_END;
   If CheckAnySign(590,'PKSFX',5) Then goto THE_END;
   If CheckAnySign(780,#3'SFX',4) Then goto THE_END;
   If CheckAnySign(09095,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(11712,'PKSFX',5) Then goto THE_END;
   If CheckAnySign(12688,'WinZip Self',11) Then goto THE_END;
   If CheckAnySign(14352,'WinZip(R) Self',14) Then goto THE_END;
   If CheckAnySign(15720,'WinZip Self',11) Then goto THE_END;
   If CheckAnySign(15750,'WinZip Self',11) Then goto THE_END;
   If CheckAnySign(15888,'WinZip(R) Self',14) Then goto THE_END;
   If CheckAnySign(16058,'WinZip',6) Then goto THE_END;
   If CheckAnySign(16112,'WinZip Self',11) Then goto THE_END;
   If CheckAnySign(16114,'WinZip Self',11) Then goto THE_END;
   If CheckAnySign(17424,'WinZip',6) Then goto THE_END;
   If CheckAnySign(17688,'GWinZip',7) Then goto THE_END;
   If CheckAnySign(20080,'WinZip Self',11) Then goto THE_END;
   If CheckAnySign(21008,'WinZip(R) Self',14) Then goto THE_END;
   If CheckAnySign(22528,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(25304,'WinZip Self',11) Then goto THE_END;
   If CheckAnySign(29848,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(30302,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(30867,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(35328,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(38483,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(39848,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(40418,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(47104,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(49235,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(51200,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(56531,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(83019,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(84992,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(86016,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(93747,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(94771,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(96832,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(101732,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(123276,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(132096,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(151704,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(154466,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(161584,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(162816,'PK'#3#4,4) Then goto THE_END;
   If CheckAnySign(Size-34,'Windows Self-Installing Executable',34) Then goto THE_END;

   Close(f);
   Exit;

   THE_END:

   Close(f);
   PKWinOS2SfxPacked := true;

 { FileMode := FMode; }
 End;

(* Ist die Datei im "Package for the Web"-Format?
   Is the file in "Package for the Web" format? *)

Function PfWPacked(ArcName: PathStr): Boolean;

 Label THE_END;

    { Var FMode: Byte; }

 Begin
   PfWPacked := false;
   s := '';
 { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
 {$IFDEF LONGNAME}
   ArcName := Strip('B','"',ArcName);
 {$ENDIF}
   Assign(f,ArcName);
   Reset(f,1);
   Size := FileSize(f);
   If CheckAnySign(18778,'MSCF',4) Then goto THE_END;
   If CheckAnySign(21770,'MSCF',4) Then goto THE_END;
   If CheckAnySign(62848,'MSCF',4) Then goto THE_END;
   Close(f);
   Exit;

   THE_END:

   Close(f);
   PfWPacked := true;

 { FileMode := FMode; }
 End;

(* Ist die Datei im "Wise-Installer"-Format?
   Is the file in "Wise Installer" format? *)

Function WisePacked(ArcName: PathStr): Boolean;

 Label THE_END;

    { Var FMode: Byte; }

 Begin
   WisePacked := false;
   s := '';
 { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
 {$IFDEF LONGNAME}
   ArcName := Strip('B','"',ArcName);
 {$ENDIF}
   Assign(f,ArcName);
   Reset(f,1);
   Size := FileSize(f);
   If CheckAnySign(45165,'MSCF',4) Then goto THE_END;
   Close(f);
   Exit;

   THE_END:

   Close(f);
   WisePacked := true;

 { FileMode := FMode; }
 End;

(* Ist die Datei im "Microsoft CAB-Installer"-Format?
   Is the file in "Microsoft CAB installer" format? *)

Function CABSfxPacked(ArcName: PathStr): Boolean;

 Label THE_END;

    { Var FMode: Byte; }

 Begin
   CABSfxPacked := false;
   s := '';
 { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
 {$IFDEF LONGNAME}
   ArcName := Strip('B','"',ArcName);
 {$ENDIF}
   Assign(f,ArcName);
   Reset(f,1);
   Size := FileSize(f);
   If CheckAnySign(18714,'MSCF',4) Then goto THE_END;
   If CheckAnySign(46068,'LIST',4) Then goto THE_END;
   If CheckAnySign(46206,'LIST',4) Then goto THE_END;
   If CheckAnySign(84788,'LIST',4) Then goto THE_END;
   If CheckAnySign(93100,'LIST',4) Then goto THE_END;
   Close(f);
   Exit;

   THE_END:
   Close(f);
   CABSfxPacked := true;

 { FileMode := FMode; }
 End;

(* Ist die Datei im "NullSoft Installer"-Format?
   Is the file in "NullSoft Installer" format? *)

Function NullSoftPacked(ArcName: PathStr): Boolean;

    { Var FMode: Byte; }
 Begin
   NullSoftPacked := false;
   s := '';
 { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
 {$IFDEF LONGNAME}
   ArcName := Strip('B','"',ArcName);
 {$ENDIF}
   Assign(f,ArcName);
   Reset(f,1);
   Size := FileSize(f);
   If Size>=Length(s) Then
     Begin
       Seek(f,36360);
       BlockRead(f,s[1],12);
       SetLength(s, 12);
       NullSoftPacked := s='NullSoftInst';
     End;
   Close(f);
 { FileMode := FMode; }
 End;

(* Ist die Datei im DZip-Sfx-Format?
   Is the file in DZip sfx format?  *)

Function DZipSfxPacked(ArcName: PathStr): Boolean;

    { VarFMode: Byte; }

 Begin
   DZipSfxPacked := false;
   s := '';
 { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
 {$IFDEF LONGNAME}
   ArcName := Strip('B','"',ArcName);
 {$ENDIF}
   Assign(f,ArcName);
   Reset(f,1);
   Size := FileSize(f);
   If Size>=Length(s) Then
     Begin
       Seek(f,1124);
       BlockRead(f,s[1],7);
       SetLength(s, 7);
       DZipSfxPacked := s='DzipSfx';
     End;
   Close(f);
 { FileMode := FMode; }
 End;

(* Ist die Datei mit aPackage gepackt?
  Is the file aPackage-packed? *)

Function aPackagePacked(ArcName: PathStr): Boolean;

    { Var FMode: Byte; }
 Begin
   aPackagePacked := false;
   s := '';
 { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
 {$IFDEF LONGNAME}
   ArcName := Strip('B','"',ArcName);
 {$ENDIF}
   Assign(f,ArcName);
   Reset(f,1);
   Size := FileSize(f);
   If Size>=Length(s) Then
     Begin
       BlockRead(f,s[1],SizeOf(s)-1);
       SetLength(s, 52);
       aPackagePacked := Pos('aPKG',s)=49;
     End;
   Close(f);
 { FileMode := FMode; }
 End;

(* Ist die Datei mit LZEXE gepackt?
  Is the file LZEXE-packed? *)

 Function LZExed(ArcName: PathStr): Boolean;

 Const BufSize = 30;

 Var   b: Array[0..BufSize] Of Byte;
       f: File;
       x {, FMode }: Byte;
 Begin
   LZExed := false;
   If FSize(ArcName)>330 Then
     Begin
       If Exist(ArcName) Then
         Begin
      { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
      {$IFDEF LONGNAME}
           ArcName := Strip('B','"',ArcName);
      {$ENDIF}
           Assign(f,ArcName);
           Reset(f,1);
           BlockRead(f,b,BufSize);
           Close(f);
      { FileMode := FMode; }
           x := b[28]; (* Nach String 'LZ' an Offset 28 suchen *)
           If x=76 Then
             Begin
               x := b[29]; (* Char 28=L?; dann weiter *)
               LZExed := x=90;
             End;
         End;
     End;
 End;

(* Ist die Datei mit PKLite gepackt?
  Is the file PKLite-packed? *)

 Function PKExed(ArcName: PathStr): Boolean;

 Const BufSize = 48;

 Var   b: Array[0..BufSize] Of Byte;
       f: File;
       x {, FMode}: Byte;
 Begin
   PKExed := false;
   If FSize(ArcName)>330 Then
     Begin
       If Exist(ArcName) Then
         Begin
      { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
      {$IFDEF LONGNAME}
           ArcName := Strip('B','"',ArcName);
      {$ENDIF}
           Assign(f,ArcName);
           Reset(f,1);
           BlockRead(f,b,BufSize);
           Close(f);
      { FileMode := FMode; }
           x := b[30]; (* Nach String 'PK' an Offset 30 suchen *)
           If x=80 Then
             Begin
               x := b[31]; (* Char 30=P?; dann weiter *)
               If x=75 Then
                 Begin
                   PKExed := true;
                   Exit;
                 End;
             End;
           x := b[46]; (* Nach String 'PK' an Offset 46 suchen *)
           If x=80 Then
             Begin
               x := b[47]; (* Char 46=P?; dann weiter *)
               PKExed := x=75;
             End;
         End;
     End;
 End;

(* Ist die Datei mit Diet gepackt?
  Is the file Diet-packed? *)

 Function Dieted(ArcName: PathStr): Boolean;

 Const BufSize = $6F;

 Var   b: Array[0..BufSize] Of Byte;
       f: File;
       x1,x2{ ,FMode }: Byte;
       dlz: String[3];
 Begin
   Dieted := false;
   If FSize(ArcName)>330 Then
     Begin
       If Exist(ArcName) Then
         Begin
      { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
      {$IFDEF LONGNAME}
           ArcName := Strip('B','"',ArcName);
      {$ENDIF}
           Assign(f,ArcName);
           Reset(f,1);
           BlockRead(f,b,BufSize);
           Close(f);
      { FileMode := FMode; }
           dlz := '';
           x1 := b[0];
           x2 := b[1];
           System.Move(b[$23],dlz[1],3); (* Nach String 'dlz' an Offset 23h suchen *)
           dlz[0] := #3;
           If (dlz='dlz') And (x1=$B) And (x2=$E) Then
             Begin
               Dieted := true;
               Exit;
             End;
           dlz := '';
           System.Move(b[$41],dlz[1],3); (* Nach String 'dlz' an Offset 41h suchen *)
           dlz[0] := #3;
           If (dlz='dlz') And (x1=$F9) And (x2=$9C) Then
             Begin
               Dieted := true;
               Exit;
             End;
           dlz := '';
           x1 := b[$12];
           x2 := b[$13];
           System.Move(b[$57],dlz[1],3); (* Nach String 'dlz' an Offset 57h suchen *)
           dlz[0] := #3;
           If (dlz='dlz') And (x1=$9D) And (x2=$89) Then
             Begin
               Dieted := true;
               Exit;
             End;
           dlz := '';
           x1 := b[0];
           x2 := b[1];
           System.Move(b[$57],dlz[1],3); (* Nach String 'dlz' an Offset 57h suchen *)
           dlz[0] := #3;
           If (dlz='dlz') And (x1=$9D) And (x2=$89) Then
             Begin
               Dieted := true;
               Exit;
             End;
           dlz := '';
           x1 := b[$12];
           x2 := b[$13];
           System.Move(b[$6B],dlz[1],3); (* Nach String 'dlz' an Offset 6Bh suchen *)
           dlz[0] := #3;
           If (dlz='dlz') And (x1=$9D) And (x2=$89) Then
             Begin
               Dieted := true;
               Exit;
             End;
           dlz := '';
           System.Move(b[$6C],dlz[1],3); (* Nach String 'dlz' an Offset 6Ch suchen *)
           dlz[0] := #3;
           Dieted := (dlz='dlz') And (x1=$9D) And (x2=$89);
         End;
     End;
 End;

(* Ist die Datei mit TinyProg gepackt?
  Is the file TinyProg-packed? *)

 Function TPExed(ArcName: PathStr): Boolean;

 Const BufSize = 30;

 Var   b: Array[0..BufSize] Of Byte;
       f: File;
       x {, FMode}: Byte;
 Begin
   TPExed := false;
   If FSize(ArcName)>330 Then
     Begin
       If Exist(ArcName) Then
         Begin
      { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
      {$IFDEF LONGNAME}
           ArcName := Strip('B','"',ArcName);
      {$ENDIF}
           Assign(f,ArcName);
           Reset(f,1);
           BlockRead(f,b,BufSize);
           Close(f);
      { FileMode := FMode; }
           x := b[28]; (* Nach String 'tz' an Offset 28 suchen *)
           If x=116 Then
             Begin
               x := b[29]; (* Char 28=t?; dann weiter *)
               TPExed := x=122;
             End;
         End;
     End;
 End;

Function EXEPacked(ArcName: PathStr): Boolean;
 Begin
   EXEPacked := LZExed(ArcName) Or PKExed(ArcName) Or Dieted(ArcName) Or TPExed(ArcName);
 End;

Function WWPackPacked(ArcName: PathStr): Boolean;

    { Var FMode: Byte; }
 Begin
   WWPackPacked := false;
   s := '';
 { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
 {$IFDEF LONGNAME}
   ArcName := Strip('B','"',ArcName);
 {$ENDIF}
   Assign(f,ArcName);
   Reset(f,1);
   Size := FileSize(f);
   If Size>=Length(s) Then
     Begin
       BlockRead(f,s[1],SizeOf(s)-1);
       SetLength(s, 31);
       WWPackPacked := (Pos('WWP',s)=29);
     End;
   Close(f);
 { FileMode := FMode; }
 End;

Function ARXSfxPacked(ArcName: PathStr): Boolean;

    { Var FMode: Byte; }
 Begin
   ARXSfxPacked := false;
   s := '';
 { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
 {$IFDEF LONGNAME}
   ArcName := Strip('B','"',ArcName);
 {$ENDIF}
   Assign(f,ArcName);
   Reset(f,1);
   Size := FileSize(f);
   If Size>=Length(s) Then
     Begin
       BlockRead(f,s[1],SizeOf(s)-1);
       SetLength(s, 41);
       ARXSfxPacked := (Pos('$ARX',s)=6) Or (Pos('$ARX',s)=38);
     End;
   Close(f);
 { FileMode := FMode; }
 End;

Function LHArcSfxPacked(ArcName: PathStr): Boolean;

    { Var FMode: Byte; }
 Begin
   LHArcSfxPacked := false;
   s := '';
 { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
 {$IFDEF LONGNAME}
   ArcName := Strip('B','"',ArcName);
 {$ENDIF}
   Assign(f,ArcName);
   Reset(f,1);
   Size := FileSize(f);
   If Size>=Length(s) Then
     Begin
       BlockRead(f,s[1],SizeOf(s)-1);
       SetLength(s, 49);
       LHarcSfxPacked := (Pos('LHarc''s SFX',s)=7) Or (Pos('LHarc''s SFX',s)=39);
     End;
   Close(f);
 { FileMode := FMode; }
 End;

Function LZSSfxPacked(ArcName: PathStr): Boolean;

    { Var FMode: Byte; }

 Begin
   LZSSfxPacked := false;
   s := '';
 { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
 {$IFDEF LONGNAME}
   ArcName := Strip('B','"',ArcName);
 {$ENDIF}
   Assign(f,ArcName);
   Reset(f,1);
   Size := FileSize(f);
   If Size>=Length(s) Then
     Begin
       BlockRead(f,s[1],SizeOf(s)-1);
       SetLength(s, 43);
       LZSSfxPacked := (Pos('SFX by LARC',s)=33);
     End;
   Close(f);
 { FileMode := FMode; }
 End;

Function CompackSfxPacked(ArcName: PathStr): Boolean;

    { Var FMode: Byte; }

 Begin
   CompackSfxPacked := false;
   s := '';
 { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
 {$IFDEF LONGNAME}
   ArcName := Strip('B','"',ArcName);
 {$ENDIF}
   Assign(f,ArcName);
   Reset(f,1);
   Size := FileSize(f);
   If Size>=Length(s) Then
     Begin
       Seek(f,100);
       BlockRead(f,s[1],SizeOf(s)-1);
       SetLength(s, 11);
       CompackSfxPacked := (Pos('Collis'#0#0'SFX',s)=1);
     End;
   Close(f);
 { FileMode := FMode; }
 End;

(* Ist die Datei ein Windows-InstallShield-Sfx?
  Is the file a Windows InstallShield sfx? *)

Function InstallShieldPacked(ArcName: PathStr): Boolean;

    { Var FMode: Byte; }

 Begin
   InstallShieldPacked := false;
   If IsEXE(ArcName) Then
     Begin
       s := '';
   { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
   {$IFDEF LONGNAME}
       ArcName := Strip('B','"',ArcName);
   {$ENDIF}
       Assign(f,ArcName);
       Reset(f,1);
       Size := FileSize(f);
       If Size>=Length(s) Then
         If Size>=Length(s)+$3AF Then
           Begin
            Seek(f,$3AF);
            BlockRead(f,s[1],SizeOf(s)-1);
             SetLength(s, 18);
            InstallShieldPacked := s='InstallShield Self';
           End;
       Close(f);
   { FileMode := FMode; }
     End;
 End;

Function ID_at_end(ArcName: PathStr; ID: Byte): Boolean;

 Var f: File Of Byte;
    s: String[5];
    c,i {,FMode}: Byte;
 Begin
   ID_at_end := false;
   s := '';
 { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
 {$IFDEF LONGNAME}
   ArcName := Strip('B','"',ArcName);
 {$ENDIF}
   Assign(f,ArcName);
   Reset(f);
   Size := FileSize(f);
   If Size>=Length(s) Then
     Begin
       Seek(f,FileSize(f)-5);
       For i := 1 To 5 Do
         Begin
           Read(f,c);
           s[i] := Char(c);
         End;
       s[0] := #5;
       If ID=ARJType Then ID_at_end := Copy(s,2,4)=#$60#$EA#0#0
       Else
         If ID=DWCType Then ID_at_end := Copy(s,3,3)='DWC'
       Else
         If ID=ZARType Then ID_at_end := Copy(s,3,2)='PT'
       Else
         If ID=ARGType Then ID_at_end := Copy(s,5,1)=#1
       Else
         If ID=PC3Type Then ID_at_end := Copy(s,4,2)=#$E0#$E0
       Else
         If ID=IiType  Then ID_at_end := Copy(s,1,5)='xxx32'
       Else
         If (ID=XDIType) Or (ID=XpdType) Then ID_at_end := Copy(s,4,2)='jm'
       Else
         If ID=RKType  Then ID_at_end := ((s[1]=#129) And (Copy(s,4,2)='RK'))
       Else
         If ID=PAKType Then ID_at_end := Copy(s,4,1)=#$FE
       Else
         If ID=RKVType Then If (((Copy(s,3,2)=#0#0) And (s[5] In [#$30..#$7A]))) Or
                               (Copy(s,4,2)='RK') Then ID_at_end := true;
     End;
   Close(f);
 { FileMode := FMode; }
 End;

(* Ist die Datei ein RAR-DOS-, Win- oder OS/2-Sfx?
   Is the file a RAR DOS, Win or OS/2 sfx?         *)

Function RARSfxPacked(ArcName: PathStr): Boolean;

 Label THE_END;

    { Var FMode: Byte; }

 Begin
   RARSfxPacked := false;
   s := '';
  { FMode := FileMode; FileMode := 0 OR 1 SH6; }
  {$IFDEF LONGNAME}
   ArcName := Strip('B','"',ArcName);
  {$ENDIF}
   Assign(f,ArcName);
   Reset(f,1);
   Size := FileSize(f);
   If size>=32 Then
     Begin
       BlockRead(f,s[1],32);
       SetLength(s, 32);
       If Pos('RSFX',s)=29 Then goto THE_END;
     End;
   If CheckAnySign(12960,'Rar!',4) Then goto THE_END;
   If CheckAnySign(13312,'Rar!',4) Then goto THE_END;
   If CheckAnySign(13824,'Rar!',4) Then goto THE_END;
   If CheckAnySign(13905,'Rar!',4) Then goto THE_END;
   If CheckAnySign(17678,'Rar!',4) Then goto THE_END;
   If CheckAnySign(17721,'Rar!',4) Then goto THE_END;
   If CheckAnySign(17952,'Rar!',4) Then goto THE_END;
   If CheckAnySign(18274,'Rar!',4) Then goto THE_END;
   If CheckAnySign(23040,'Rar!',4) Then goto THE_END;
   If CheckAnySign(24074,'Rar!',4) Then goto THE_END;
   If CheckAnySign(24132,'Rar!',4) Then goto THE_END;
   If CheckAnySign(24788,'Rar!',4) Then goto THE_END;
   If CheckAnySign(25044,'Rar!',4) Then goto THE_END;
   If CheckAnySign(28160,'Rar!',4) Then goto THE_END;
   If CheckAnySign(31232,'Rar!',4) Then goto THE_END;
   If CheckAnySign(33280,'Rar!',4) Then goto THE_END;
   If CheckAnySign(36864,'Rar!',4) Then goto THE_END;
   If CheckAnySign(37376,'Rar!',4) Then goto THE_END;
   If CheckAnySign(37888,'Rar!',4) Then goto THE_END;
   If CheckAnySign(38912,'Rar!',4) Then goto THE_END;
   If CheckAnySign(40456,'Rar!',4) Then goto THE_END;
   If CheckAnySign(46080,'Rar!',4) Then goto THE_END;
   If CheckAnySign(46592,'Rar!',4) Then goto THE_END;
   If CheckAnySign(47104,'Rar!',4) Then goto THE_END;
   If CheckAnySign(49152,'Rar!',4) Then goto THE_END;
   If CheckAnySign(49355,'Rar!',4) Then goto THE_END;
   If CheckAnySign(49576,'Rar!',4) Then goto THE_END;
   If CheckAnySign(49664,'Rar!',4) Then goto THE_END;
   If CheckAnySign(50176,'Rar!',4) Then goto THE_END;
   If CheckAnySign(54784,'Rar!',4) Then goto THE_END;
   If CheckAnySign(55296,'Rar!',4) Then goto THE_END;
   If CheckAnySign(55808,'Rar!',4) Then goto THE_END;
   If CheckAnySign(57344,'Rar!',4) Then goto THE_END;
   If CheckAnySign(57856,'Rar!',4) Then goto THE_END;
   If CheckAnySign(58368,'Rar!',4) Then goto THE_END;
   If CheckAnySign(58773,'Rar!',4) Then goto THE_END;
   If CheckAnySign(58880,'Rar!',4) Then goto THE_END;
   If CheckAnySign(61440,'Rar!',4) Then goto THE_END;
   If CheckAnySign(64000,'Rar!',4) Then goto THE_END;
   If CheckAnySign(66560,'Rar!',4) Then goto THE_END;
   If CheckAnySign(69120,'Rar!',4) Then goto THE_END;
   If CheckAnySign(69632,'Rar!',4) Then goto THE_END;
   If CheckAnySign(71168,'Rar!',4) Then goto THE_END;
   If CheckAnySign(71680,'Rar!',4) Then goto THE_END;
   If CheckAnySign(89088,'Rar!',4) Then goto THE_END;
   If CheckAnySign(89600,'Rar!',4) Then goto THE_END;
   If CheckAnySign(90624,'Rar!',4) Then goto THE_END;
   If CheckAnySign(91136,'Rar!',4) Then goto THE_END;
   If CheckAnySign(93184,'Rar!',4) Then goto THE_END;
   If CheckAnySign(93696,'Rar!',4) Then goto THE_END;
   If CheckAnySign(93816,'Rar!',4) Then goto THE_END;
   If CheckAnySign(93824,'Rar!',4) Then goto THE_END;
   If CheckAnySign(93860,'Rar!',4) Then goto THE_END;
   If CheckAnySign(93868,'Rar!',4) Then goto THE_END;
   If CheckAnySign(93892,'Rar!',4) Then goto THE_END;
   If CheckAnySign(93932,'Rar!',4) Then goto THE_END;
   If CheckAnySign(93964,'Rar!',4) Then goto THE_END;
   If CheckAnySign(94016,'Rar!',4) Then goto THE_END;
   If CheckAnySign(94128,'Rar!',4) Then goto THE_END;
   If CheckAnySign(94172,'Rar!',4) Then goto THE_END;
   If CheckAnySign(95020,'Rar!',4) Then goto THE_END;
   If CheckAnySign(98304,'Rar!',4) Then goto THE_END;
   If CheckAnySign(98816,'Rar!',4) Then goto THE_END;
  Close(f);
  Exit;

   THE_END:

   Close(f);
   RARSfxPacked := true;

 { FileMode := FMode; }
 End;

(* Ist die Datei ein ZZip-Sfx?
   Is the file a ZZip sfx?

   Funktion optimiert von Snow Panther, danke!
   Function optimized by Snow Panther, thanks! *)

Function ZZipSfxPacked(ArcName: PathStr): Boolean;

 Label THE_END;

   { Var FMode : Byte; }

Begin
  ZZipSfxPacked := false;
  s := '';
 { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
 {$IFDEF LONGNAME}
  ArcName := Strip('B','"',ArcName);
 {$ENDIF}
  Assign(f,ArcName);
  Reset(f,1);
  Size := FileSize(f)-5; {5 = length}
  If CheckAnySign(19968,'ZZ0',3) Then goto THE_END;
  Close(f);
  Exit;

  THE_END:

  Close(f);
  ZZipSfxPacked := true;

 { FileMode := FMode; }
End;


Function PakDDPacked(ArcName: PathStr): Boolean;

 Var f: File Of Word;
    w1,w2,w3,w4: Word;
    w: LongInt;
    { FMode: Byte; }
 Begin
   PakDDPacked := false;
 {$IFDEF LONGNAME}
   ArcName := Strip('B','"',ArcName);
 {$ENDIF}
   Assign(f,ArcName);
   Reset(f);
   Size := FileSize(f);
   If Size>=8 Then
     Begin
       Read(f,w1);
       Read(f,w2);
       Read(f,w3);
       Read(f,w4);
       w := w1+w2+w3+w4;
       PakDDPacked := w=$AAAA;
     End;
   Close(f);
 { FileMode := FMode; }
 End;

Function ArcMethod(ArcName: PathStr): Byte;

 Const PAKId = $0A;
      HYPId = $48;
      ARPId = $14;
      ARCId = $1A;

 Var ArcHeader : Record
                   Marker: Byte;
                   Method: Byte;
                   Name  : Array[1..13] Of Char;
                   Size  : LongInt;
                   Stamp : LongInt;
                   CRC   : Word;
                   Length: LongInt;
                End;
    NotOK,IsEx: Boolean;
    f         : File;
    ArcTyp,
    { FMode     : Byte; }
    ExeLen    : LongInt;
 Begin
   If IsExe(ArcName) Then
     Begin
       IsEx := true;
       ExeLen := ExeSize(ArcName);
     End
   Else
   begin
     IsEx := false;
     ExeLen := 0;
   end;
 { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
 {$IFDEF LONGNAME}
   ArcName := Strip('B','"',ArcName);
 {$ENDIF}
   Assign(f,ArcName);
   Reset(f,1);
   NotOK := false;
   ArcTyp := Invalid;
   If IsEx Then Seek(f,ExeLen);
   Repeat
     Blockread(f,ArcHeader,SizeOf(ArcHeader));
     If (IOResult=0) Or (IOResult=100) Then
       Begin
         If ArcHeader.Marker=ARCId Then
           Begin
             ArcTyp := ARCType;
             If ArcHeader.Method>=PAKid Then
               Begin
                 NotOK := true;
                 If (ArcHeader.Name[11]=#$14) And (ArcHeader.Name[12]=#$15) And
                    (ArcHeader.Name[13]=#$13) Or (ID_at_End(ArcName,PakType)) Then ArcTyp
                   := PAKType;
                 If ArcHeader.Method >= HYPid Then
                   ArcTyp := HYPType
                 Else
                   If ArcHeader.Method=ARPid Then ArcTyp := ARCPlusType;
               End;
           End
         Else NotOK := true;
       End
     Else NotOK := true;
   Until NotOK;
   Close(f);
 { FileMode := FMode; }
   ArcMethod := ArcTyp;
 End;

Function OpenArchive(ArcName: PathStr): Boolean;

 Const MinSize = 20;

 Var f: File;
    IO: Word;
    { FMode, }
   BufLen: Byte;
    Offset,ExeLen,Size: LongInt;
 Begin
   OpenArchive := false;

 { FMode := FileMode; FileMode := 0 OR 1 SHL 6; }
 {$IFDEF LONGNAME}
   ArcName := Strip('B','"',ArcName);
 {$ENDIF}
   Assign(f,ArcName);
   If IOResult<>0 then Exit;	{ rar }
   Reset(f,1);
   Size := FileSize(f);
   Close(f);
   If Size>=MinSize Then
     Begin
       Offset := 0;
       ExeLen := 0;
       If IsExe(ArcName) Then
         Begin
          IsEx := true;
          ExeLen := ExeSize(ArcName);
          Inc(Offset,ExeLen);
         End Else IsEx := false;
       If ExeLen=Size Then
         Begin
          IDStr := '';
          OpenArchive := true;
          Exit;
         End;
       Assign(f,ArcName);
       Reset(f,1);
       BufLen := SizeOf(IDStr)-1;
       If Size<BufLen Then Buflen := Size;
       IO := IOResult;
       If Size>=MinSize Then
         If (IO=0) Or (IO=100) Then
           Begin
            If (Offset<>0) And (Offset>=ExeLen) Then Seek(f,Offset);
            Blockread(f,IDStr[1],BufLen);
            SetLength(IDStr, BufLen);
            Close(f);
            OpenArchive := true;
           End;
  { FileMode := FMode; }
     End;
 End;

Function ArchiveType(ArcName: PathStr): Byte;

   Var o,p,q,r: Byte;
 Begin
   ArchiveType := Invalid;
   NewIsC := FALSE;

   If Not Exist(ArcName) Then ArchiveType := FileNotFound
   Else
     Begin
       If Not OpenArchive(ArcName) Then Exit
       Else
         Begin
           p := Pos('CRUSH$',IDStr);
           q := Pos('.CRU',IDStr);
           r := Pos('.cru',IDStr);
           o := Pos('CRUSH',IDStr);
           If (p=35) Or (q In [24..39]) Or (r In [24..31,82..89]) Or (o=1) Then
             Begin
               CrushPacked := true;
               If o=1 Then ArchiveType := CruType
               Else
                 If Pos('PK'#3#4,IDStr)=1 Then ArchiveType := CruPType
               Else
                 If (Pos(#$60#$EA,IDStr)=1) Or (Pos(#$60#$EA,IDStr)=3) Or (Pos('.ARJ',
                    IDStr)=41) Then
                   ArchiveType := CruJType
               Else
                 If Pos('-lh',IDStr)=3 Then ArchiveType := CruLType
               Else
                 If Pos('ZOO',IDStr)=1 Then ArchiveType := CruZType
               Else
                 If Pos('HA',IDStr)=1 Then ArchiveType := CruHType;
               Exit;
             End;
           If (Pos('PK'#3#4,IDStr)=1) Or (Pos('PK00PK',IDStr)=1) Then
             Begin
               ArchiveType := ZIPType;
               Exit;
             End
           Else If PKWinOS2SfxPacked(ArcName) Then
                  Begin
                    ArchiveType := ZIPType;
                    Exit;
                  End;
           If (Pos(#31#139#8#8,IDStr)=1) Or (Pos(#$1F#$9D#$90,IDStr)=1) Then
             Begin
               ArchiveType := GZIPType;
               Exit;
             End;
           If (Pos(#$60#$EA,IDStr)=1) Or (Pos(#$60#$EA,IDStr)=3) Or
              ArjWinSfxPacked(ArcName) Or ArjDOSSfxPacked(ArcName) Or
              ID_at_end(Arcname,ARJType) Then
             Begin
               ArchiveType := ARJType;
               mv := (VolumeFlag(IDStr[9],ARJType) Or VolumeFlag(IDStr[11],ARJType));
               If Pos(#$60#$EA,IDStr)=1 Then av := AVFlag(IDStr[9],ARJType)
               Else
                 If (Pos(#$60#$EA,IDStr)=3) Then av := AVFlag(IDStr[11],ARJType);
               If Pos('.SRJ',CapStr(ArcName))<>0 Then ArchiveType := SARJType;
               Exit;
             End;
           If (Pos(#26'Jar'#27#0,IDStr)=15) Then
             Begin
               ArchiveType := JRType;
               Exit;
             End;
           If (Pos('RE'#$7E#$5E,IDStr)=1) Or (Pos('Rar',IDStr)=1) Or
              RARSfxPacked(ArcName) Then
             Begin
               ArchiveType := RARType;
               mv := VolumeFlag(IDStr[11],RARType);
               av := AVFlag(IDStr[11],RARType);
               Exit;
             End;
           If Pos('**ACE**',IDStr)=8 Then
             Begin
               ArchiveType := AceType;
               mv := VolumeFlag(IDStr[7],ACEType);
               av := AVFlag(IDStr[7],ACEType);
               Exit;
             End;
           If AceSfxPacked(ArcName) Then
             Begin
               ArchiveType := AceType;
               Exit;
             End;
           If Pos('HLSQZ',IDStr)=1 Then
             Begin
               ArchiveType := SQZType;
               Exit;
             End;
           If Pos('SQWEZ',IDStr)=1 Then
             Begin
               ArchiveType := SQWEZType;
               Exit;
             End;
           If Pos('HPAK',IDStr)=1 Then
             Begin
               ArchiveType := HPKType;
               Exit;
             End;
           If Pos('ë3HF',IDStr)=1 Then
             Begin
               ArchiveType := HAPType;
               Exit;
             End;
           If Pos(#$DC#$A7#$C4#$FD,IDStr)=21 Then
             Begin
               ArchiveType := ZOOType;
               Exit;
             End;
           If Pos('HA',IDStr)=1 Then
             Begin
               ArchiveType := HAType;
               Exit;
             End;
           If Pos('MDmd',IDStr)=1 Then
             Begin
               ArchiveType := MDType;
               Exit;
             End;
           If (Pos('LM'#$1A#8#0,IDStr)=1) Or (Pos('LM'#$1A#7#0,IDStr)=1) Then
             Begin
               ArchiveType := LIMType;
               Exit;
             End;
           If Pos('LH5',IDStr)=4 Then
             Begin
               ArchiveType := SARType;
               Exit;
             End;
           If Pos(#212#3'SB '#0,IDStr)=1 Then
             Begin
               ArchiveType := BS2Type;
               Exit;
             End;
           If ((Pos('-ah',IDStr)=3) And (IDStr[7]='-')) Then
             Begin
               ArchiveType := MARType;
               Exit;
             End;
           If ((Pos(#$80,IDStr)=2) Or (Pos(#$81,IDStr)=2) Or
              (Pos(#$82,IDStr)=2) Or (Pos(#$83,IDStr)=2) Or
              (Pos(#$84,IDStr)=2)) And
              (Pos(#0,IDStr)=4) Then
             Begin
               ArchiveType := ACBType;
               Exit;
             End;
           If (Pos(#0#0#0,IDStr)=2) And (GetExt(CapStr(ArcName))='.CPZ') Then
             Begin
               ArchiveType := CPZType;
               Exit;
             End;
           If Pos('JRchive',IDStr)=1 Then
             Begin
               ArchiveType := JRCType;
               Exit;
             End;
           If Pos('JARCS',IDStr)=1 Then
             Begin
               ArchiveType := JARType;
               Exit;
             End;
           If Pos('DS'#0,IDStr)=1 Then
             Begin
               ArchiveType := QType;
               Exit;
             End;
           If Pos('PK'#3#6,IDStr)=1 Then
             Begin
               ArchiveType := SOFType;
               Exit;
             End;
           If Pos('7'#04,IDStr)=1 Then
             Begin
               ArchiveType := QARKType;
               Exit;
             End;
           If Pos('YC',IDStr)=15 Then
             Begin
               ArchiveType := YACType;
               Exit;
             End;
           If (Pos('X1',IDStr)=1) Or (Pos('XhDr',IDStr)=1) Then
             Begin
               ArchiveType := X1Type;
               Exit;
             End;
           If ((Pos(#$76#$FF,IDStr)=1) Or (Pos(#$76#$FF,IDStr)=5)) And
              ((IDStr[3] In [#$20..#$3F]) Or (IDStr[7] In [#$20..#$3F])) And
              (Pos('.DQT',ArcName)=0) Then
             Begin
               ArchiveType := CDCType;
               Exit;
             End;
           If Pos(#$AD'6"',IDStr)=1 Then
             Begin
               ArchiveType := AMGType;
               Exit;
             End;
           If Pos('NıFÈlÂ',IDStr)=1 Then
             Begin
               ArchiveType := NLIType;
               Exit;
             End;
           If Pos('LEOLZW',IDStr)=1 Then
             Begin
               ArchiveType := PLLType;
               Exit;
             End;
           If Pos(#$1F#$8B#$08,IDStr)=1 Then
             Begin
               ArchiveType := TGZType;
               Exit;
             End;
           If Pos('SChF',IDStr)=1 Then
             Begin
               ArchiveType := CHZType;
               Exit;
             End;
           If Pos('PSA',IDStr)=1 Then
             Begin
               ArchiveType := PSAType;
               Exit;
             End;
           If Pos('DSIGDCC',IDStr)=1 Then
             Begin
               ArchiveType := PACType;
               Exit;
             End;
           If Pos(#$1F#$9F#$4A#$10#$0A,IDStr)=1 Then
             Begin
               ArchiveType := XFType;
               Exit;
             End;
           If Pos('®MP®',IDStr)=1 Then
             Begin
               ArchiveType := KBOType;
               Exit;
             End;
           If Pos(#$76#$FF,IDStr)=1 Then
             Begin
               ArchiveType := NSQType;  (* Muss _nach_ CdcType geprueft werden. *)
               Exit;                    (* Has to be tested _after_ CdcType.    *)
             End;
           If Pos('Dirk Paehl',IDStr)=1 Then
             Begin
               ArchiveType := DPAType;
               Exit;
             End;
           If (Not IsEXE(ArcName)) And (IDStr<>'') And
              (Copy(IDStr,1,3)=Copy(IDStr,4,3)) And (GetExt(CapStr(ArcName))='.BA') Then
             Begin
               ArchiveType := BaType;
               Exit;
             End;
           If (Pos(#0#6,IDStr)=1) And (Not ID_at_end(ArcName,ZARType)) Then
             Begin
               ArchiveType := TTCType;
               Exit;
             End;
           If Pos('ESP',IDStr)=1 Then
             Begin
               ArchiveType := ESPType;
               Exit;
             End;
           If Pos(#1'ZPK'#1,IDStr)=1 Then
             Begin
               ArchiveType := ZPKType;
               Exit;
             End;
           If Pos(#$BC#$40,IDStr)=1 Then
             Begin
               ArchiveType := SkyType;
               Exit;
             End;
           If Pos('UFA',IDStr)=1 Then
             Begin
               ArchiveType := UfaType;
               Exit;
             End;
           If Pos('-H2O',IDStr)=1 Then
             Begin
               ArchiveType := DRYType;
               Exit;
             End;
           If Pos('MSCF',IDStr)=1 Then
             Begin
               ArchiveType := CABType;
               Exit;
             End;
           If Pos('FOXSQZ',IDStr)=1 Then
             Begin
               ArchiveType := FSqzType;
               Exit;
             End;
           If Pos(',AR7',IDStr)=1 Then
             Begin
               ArchiveType := AR7Type;
               Exit;
             End;
           If Pos('PPMZ',IDStr)=1 Then
             Begin
               ArchiveType := PPMZType;
               Exit;
             End;
           If Pos(#$88#$F0#$27,IDStr)=5 Then
             Begin
               ArchiveType := ExpType;
               Exit;
             End;
           If Pos('MP3'#$1A,IDStr)=1 Then
             Begin
               ArchiveType := MP3Type;
               Exit;
             End;
           If Pos('OZ›',IDStr)=1 Then
             Begin
               ArchiveType := ZetType;
               Exit;
             End;
           If Pos(#$65#$5D#$13#$8C#$08#$01#$03#$00,IDStr)=1 Then
             Begin
               ArchiveType := TSCType;
               Exit;
             End;
           If Pos('gW'#4#1,IDStr)=1 Then
             Begin
               ArchiveType := ArqType;
               Exit;
             End;
           If Pos('OctSqu',IDStr)=4 Then
             Begin
               ArchiveType := ArhType;
               Exit;
             End;
           If Pos(#5#1#1#0,IDStr)=1 Then
             Begin
               ArchiveType := TerType;
               Exit;
             End;
           If Pos('SIT!',IDStr)=1 Then
             Begin
               ArchiveType := SitType;
               Exit;
             End;
           If Pos(#$01#$08#$0B#$08#$EF#$00#$9E#$32#$30#$36#$31,IDStr)=1 Then
             Begin
               ArchiveType := PucType;
               Exit;
             End;
           If Pos('UHA',IDStr)=1 Then
             Begin
               ArchiveType := UHaType;
               Exit;
             End;
           If (Pos(#2'AB',IDStr)=1) Or (Pos(#3'AB2',IDStr)=1) Then
             Begin
               ArchiveType := AbcType;
               Exit;
             End;
           If Pos('CO'#0,IDStr)=1 Then
             Begin
               ArchiveType := CmpType;
               Exit;
             End;
           If Pos('âLZO',IDStr)=1 Then
             Begin
               ArchiveType := LZOType;
               Exit;
             End;
           If Pos(#$93#$B9#$06,IDStr)=1 Then
             Begin
               ArchiveType := SplType;
               Exit;
             End;
           If Pos(#$13#$5D#$65#$8C,IDStr)=1 Then
             Begin
               ArchiveType := IShZType;
               Exit;
             End;
           If Pos('GTH',IDStr)=2 Then
             Begin
               ArchiveType := GthType;
               Exit;
             End;
           If Pos('BOA',IDStr)=1 Then
             Begin
               ArchiveType := BoaType;
               Exit;
             End;
           If Pos('ULEB'#$A,IDStr)=1 Then
             Begin
               ArchiveType := RaxType;
               Exit;
             End;
           If Pos('ULEB'#0,IDStr)=1 Then
             Begin
               ArchiveType := XTType;
               Exit;
             End;
           If (Pos('BZ',IDStr)=1) And (IDStr[3] In ['0'..'9']) And (IDStr[4] In ['0'..'9']) Then
             Begin
               ArchiveType := BZipType;
               Exit;
             End;
           If (Pos('BZ',IDStr)=1) And (IDStr[3]='h') And (IDStr[4] In ['0'..'9']) Then
             Begin
               ArchiveType := BZip2Type;
               Exit;
             End;
           If Pos('@‚'#1#0,IDStr)=1 Then
             Begin
               ArchiveType := PckType;
               Exit;
             End;
           If (IDStr[1] In [#$1A..#$1B]) And (Pos(#3'Descript',IDStr)=2) Then
             Begin
               ArchiveType := BtsType;
               Exit;
             End;
           If Pos('Ora ',IDStr)=1 Then
             Begin
               ArchiveType := EliType;
               Exit;
             End;
           If (Pos(#$1A'FC'#$1A,IDStr)=1) Or (Pos(#$1A'QF'#$1A,IDStr)=1)  Then
             Begin
               ArchiveType := QfcType;
               Exit;
             End;
           If Pos('RNC',IDStr)=1 Then
             Begin
               ArchiveType := RncType;
               Exit;
             End;
           If Pos('777',IDStr)=1 Then
             Begin
               ArchiveType := _777Type;
               Exit;
             End;
           If Pos('sTaC',IDStr)=1 Then
             Begin
               ArchiveType := StacType;
               Exit;
             End;
           If Pos('HPA',IDStr)=1 Then
             Begin
               ArchiveType := HpaType;
               Exit;
             End;
           If Pos('LG',IDStr)=1 Then
             Begin
               ArchiveType := LgType;
               Exit;
             End;
           If Pos('0123456789012345BZh91AY&SY',IDStr)=1 Then
             Begin
               ArchiveType := Exp1Type;
               Exit;
             End;
           If Pos('IMP'#$A,IDStr)=1 Then
             Begin
               ArchiveType := ImpType;
               Exit;
             End;
           If Pos(#0#$9E#$6E#$72#$76#$FF,IDStr)=1 Then
             Begin
               ArchiveType := NrvType;
               Exit;
             End;
           If PakDDPacked(ArcName) Then
             Begin
               ArchiveType := PddType;
               Exit;
             End;
           If Pos(#$73#$B2#$90#$F4,IDStr)=1 Then
             Begin
               ArchiveType := SqType;
               Exit;
             End;
           If (Pos('PHILIPP',IDStr)=1) Or (Pos('PAR',IDStr)=1) Then
             Begin
               ArchiveType := ParType;
               Exit;
             End;
           If Pos('UB',IDStr)=1 Then
             Begin
               ArchiveType := HitType;
               Exit;
             End;
           If (Pos('SB',IDStr)=1) And (IDStr[3] In ['1'..'9']) Then
             Begin
               ArchiveType := SbxType;
               Exit;
             End;
           If Pos('NSK',IDStr)=1 Then
             Begin
               ArchiveType := NskType;
               Exit;
             End;
           If (Pos('# CAR archive header',IDStr)=1) or
              (Pos('CAR 2.00RG',IDStr)=1) Then
             Begin
               ArchiveType := SapType;
               Exit;
             End;
           If Pos('DST',IDStr)=1 Then
             Begin
               ArchiveType := DstType;
               Exit;
             End;
           If Pos('ASD',IDStr)=1 Then
             Begin
               ArchiveType := AsdType;
               Exit;
             End;
           If Pos('ISc(',IDStr)=1 Then
             Begin
               ArchiveType := IscType;
               If Pos(#4,IDStr)=5 Then NewIsc := false;
               Exit;
             End;
           If Pos('T4'#$1A,IDStr)=1 Then
             Begin
               ArchiveType := T4Type;
               Exit;
             End;
           If (Pos(#$EB#$BE,IDStr)=1) Or (Pos(#$BE#$EB,IDStr)=1) Then
             Begin
               ArchiveType := BtmType;
               Exit;
             End;
           If Pos('BH'#5#7,IDStr)=1 Then
             Begin
               ArchiveType := BhType;
               Exit;
             End;
           If Pos('BIX0',IDStr)=1 Then
             Begin
               ArchiveType := BixType;
               Exit;
             End;
           If Pos('ChfLZ',IDStr)=4 Then
             Begin
               ArchiveType := LzaType;
               Exit;
             End;
           If Pos('Blink',IDStr)=1 Then
             Begin
               ArchiveType := BliType;
               Exit;
             End;
           If Pos(#$DA#$FA,IDStr)=1 Then
             Begin
               ArchiveType := LgCType;
               Exit;
             End;
           If Pos('(C) STEPANYUK',IDStr)=2 Then
             Begin
               ArchiveType := ArsType;
               Exit;
             End;
           If Pos('AKT32',IDStr)=1 Then
             Begin
               ArchiveType := A32Type;
               Exit;
             End;
           If Pos('AKT',IDStr)=1 Then
             Begin
               ArchiveType := AktType;
               Exit;
             End;
           If Pos('MSTSM',IDStr)=1 Then
             Begin
               ArchiveType := NpaType;
               Exit;
             End;
           If Pos(#0#$50#0#$14,IDStr)=1 Then
             Begin
               ArchiveType := PftType;
               Exit;
             End;
           If Pos('SEM',IDStr)=1 Then
             Begin
               ArchiveType := SemType;
               Exit;
             End;
           If Pos('èØ¨Ñ',IDStr)=1 Then
             Begin
               ArchiveType := PpmType;
               Exit;
             End;
           If Pos('FIZ',IDStr)=1 Then
             Begin
               ArchiveType := FizType;
               Exit;
             End;
           If (Pos('MS',IDStr)=1) And (IDStr[3] In [#0..#15]) And (IDStr[4] In [#0..#9])
             Then
             Begin
               ArchiveType := XieType;
               Exit;
             End;
           If Pos(#$ED#$AB#$EE#$DB,IDStr)=1 Then
             Begin
               ArchiveType := RpmType;
               Exit;
             End;
           If (Pos('yz0',IDStr)=1) And (IDStr[4] In ['1'..'9']) And (IDStr[5] In ['0'..'9'
              ]) Then
             Begin
               ArchiveType := DfType;
               Exit;
             End;
           If (Pos('ZZ '#0#0,IDStr)=1) Or (Pos('ZZ0',IDStr)=1) Or ZZipSfxPacked(ArcName)
             Then
             Begin
               ArchiveType := ZZType;
               Exit;
             End;
           If (Pos('<DC-',IDStr)=1) And (Pos('>',IDStr)=9) Then
             Begin
               ArchiveType := DCType;
               Exit;
             End;
           If Pos(#4'TPAC'#3,IDStr)=1 Then
             Begin
               ArchiveType := TpcType;
               Exit;
             End;
           If (Pos('Ai'#1#1#0,IDStr)=1) Or (Pos('Ai'#1#0#0,IDStr)=1) Then
             Begin
               ArchiveType := AiType;
               Exit;
             End;
           If (Pos('Ai'#2#0,IDStr)=1) Or (Pos('Ai'#2#1,IDStr)=1) Then
             Begin
               ArchiveType := Ai32Type;
               Exit;
             End;
           If Pos('SBC',IDStr)=1 Then
             Begin
               ArchiveType := SbcType;
               Exit;
             End;
           If Pos('YBS',IDStr)=1 Then
             Begin
               ArchiveType := YbsType;
               Exit;
             End;
           If Pos(#$9E#0#0,IDStr)=1 Then
             Begin
               ArchiveType := DitType;
               Exit;
             End;
           If Pos('DMS!',IDStr)=1 Then
             Begin
               ArchiveType := DmsType;
               Exit;
             End;
           If Pos(#$8F#$AF#$AC#$8C,IDStr)=1 Then
             Begin
               ArchiveType := EpcType;
               Exit;
             End;
           If Pos('VS'#$1A,IDStr)=1 Then
             Begin
               ArchiveType := VsaType;
               Exit;
             End;
           If Pos('PDZ',IDStr)=2 Then
             Begin
               ArchiveType := PdzType;
               Exit;
             End;
           If Pos('7z'#$BC#$AF,IDStr)=1 Then
             Begin
               ArchiveType := _7zType;
               Exit;
             End;
           If Pos('rdqx',IDStr)=1 Then
             Begin
               ArchiveType := RdqType;
               Exit;
             End;
           If Pos('GCAX',IDStr)=1 Then
             Begin
               ArchiveType := GcaType;
               Exit;
             End;
           If Pos('pN',IDStr)=1 Then
             Begin
               ArchiveType := PmnType;
               Exit;
             End;
           If Pos('WINIMAGE',IDStr)=4 Then
             Begin
               ArchiveType := ImaType;
               Exit;
             End;
           If Pos('CMP0CMP',IDStr)=1 Then
             Begin
               ArchiveType := CpaType;
               Exit;
             End;
           If aPackagePacked(ArcName) Then
             Begin
               ArchiveType := ApkType;
               Exit;
             End;
           If PfWPacked(ArcName) Then
             Begin
               ArchiveType := PfWType;
               Exit;
             End;
           If WisePacked(ArcName) Then
             Begin
               ArchiveType := WiseType;
               Exit;
             End;
           If NullSoftPacked(ArcName) Then
             Begin
               ArchiveType := NullType;
               Exit;
             End;
           If ((Pos('DZ',IDStr)=1) And (IDStr[3] In [#0..#9]) And (IDStr[4] In [#0..#9])) or
              DZipSfxPacked(ArcName) Then
             Begin
               ArchiveType := DZType;
               Exit;
             End;
           If Pos('WIC',IDStr)=1 Then
             Begin
               ArchiveType := WICType;  (* Achtung: Fake-Packer *)
               Exit;
             End;
           If Pos('OWS ',IDStr)=1 Then
             Begin
               ArchiveType := OWSType;  (* Achtung: Fake-Packer *)
               Exit;
             End;
           If Pos('WWP',IDStr)=1 Then
             Begin
               ArchiveType := WWDType;
               Exit;
             End;
           If Pos('GIF',IDStr)=1 Then
             Begin
               ArchiveType := GIFType;
               Exit;
             End;
           If Pos('JFIF',IDStr)=7 Then
             Begin
               ArchiveType := JFIFType;
               Exit;
             End;
           If Pos('hsi',IDStr)=1 Then
             Begin
               ArchiveType := JHSIType;
               Exit;
             End;
           If Pos(#$81#$8A,IDStr)=1 Then
             Begin
               ArchiveType := BMFType;
               Exit;
             End;
           p := Pos(#$FF'BSG',IDStr);
           If (p=1) Or (p=2) Or (p=4) Or (Pos(#0#174#2,IDStr)=2) Or
                                   (Pos(#0#174#3,IDStr)=2) Or
                                   (Pos(#0#174#7,IDStr)=2) Then
             Begin
               ArchiveType := BSNType;
               Exit;
             End;
           If ((Pos('-l',IDStr)=3) And (IDStr[7]='-')) Or
              ((Pos('-l',IDStr)=4) And (IDStr[8]='-')) Or
              ((Pos('-l',IDStr)=12) And (IDStr[16]='-')) Or
              ((Pos('-TK1-',IDStr)=3)) Or LHarcSfxPacked(ArcName) Or LZSSfxPacked(ArcName)
             Then
             Begin
               If (Pos('-lZ',IDStr)=3) And (IDStr[7]='-') Then
                 ArchiveType := PUTType
               Else
                 If ((Pos('-lz',IDStr)=3) And (IDStr[7]='-')) Or LZSSfxPacked(ArcName)
                   Then
                   ArchiveType := LzsType
               Else
                 Begin
                   If (((Pos('-lh0-',IDStr)=3) Or (Pos('-lh1-',IDStr)=3)) And
                      (GetExt(CapStr(ArcName))='.ARX')) Then
                     Begin
                       ArchiveType := ARXType;
                       Exit;
                     End
                   Else
                     Begin
                       If Pos('-lh7-',IDStr)=3 Then
                         Begin
                           ArchiveType := LHKType;
                           Exit;
                         End
                       Else
                         Begin
                           If Pos('.CAR',CapStr(ArcName))<>0 Then
                             Begin
                               ArchiveType := CarType;
                               Exit;
                             End;
                           ArchiveType := LZHType;
                           Exit;
                         End;
                     End
                 End;
               Exit;
             End;
           If Pos('-sw1-',IDStr)=3 Then
             Begin
               ArchiveType := SwgType;
               Exit;
             End;
           If ComPackSfxPacked(ArcName) Then
             Begin
               ArchiveType := CpkType;
               Exit;
             End;
           If (Pos(#33#18,IDStr)=1) Or (Pos(#33#17,IDStr)=1) Then
             Begin
               ArchiveType := AINType;
               Exit;
             End;
           If (Pos('UC2',IDStr)=1) Or (Pos('UC2SFX Header',IDStr)=1) Then
             Begin
               ArchiveType := UC2Type;
               Exit;
             End;
           If UCEXEPacked(ArcName) Then
             Begin
               If Not ACESfxPacked(ArcName) Then ArchiveType := UCEXEType
               Else
                 ArchiveType := AceType;
               Exit;
             End;
           If AINEXEPacked(ArcName) Then
             Begin
               ArchiveType := AINEXEType;
               Exit;
             End;
           If LZEXEd(ArcName) Then
             Begin
               ArchiveType := LZEXEType;
               Exit;
             End;
           If Dieted(ArcName) Then
             Begin
               ArchiveType := DietType;
               Exit;
             End;
           If PKExed(ArcName) Then
             Begin
               ArchiveType := PKLiteType;
               Exit;
             End;
           If TPExed(ArcName) Then
             Begin
               ArchiveType := TinyProgType;
               Exit;
             End;
           If WWPackPacked(ArcName) Then
             Begin
               If Not ACESfxPacked(ArcName) Then ArchiveType := WWPType
               Else
                 ArchiveType := ACEType;
               Exit;
             End;
           If ARXSfxPacked(ArcName) Then
             Begin
               ArchiveType := ARXType;
               Exit;
             End;
           If InstallShieldPacked(ArcName) Then
             Begin
               ArchiveType := IShType;
               Exit;
             End;
           If ID_at_end(ArcName,DwcType) Then
             Begin
               ArchiveType := DwcType;
               Exit;
             End;
           If (Pos(#0,IDStr)=1) And ID_at_end(ArcName,ArgType) Then
             Begin
               ArchiveType := ArgType;
               Exit;
             End;
           If ID_at_end(ArcName,ZARType) Then
             Begin
               ArchiveType := ZARType;
               Exit;
             End;
           If ID_at_end(ArcName,PC3Type) Then
             Begin
               ArchiveType := PC3Type;
               Exit;
             End;
           If ID_at_end(ArcName,IiType) Then
             Begin
               ArchiveType := IiType;
               Exit;
             End;
           If ID_at_end(ArcName,RKVType) Then
             Begin
       (* If (Pos('',IDStr)=2) or (Pos('Ä',IDStr)=2) or (Pos('ã',IDStr)=2) or
         (Pos('Ö',IDStr)=2) or (Pos('â',IDStr)=2) then *)
               If IDStr[3] In [#0..#15] Then
                 Begin
                   ArchiveType := RKVType;
                   Exit;
                 End;
             End;
           If ID_at_end(ArcName,RKType) Then
             Begin
               ArchiveType := RKType;
               Exit;
             End;
           If ID_at_end(ArcName,XdiType) Then
             Begin
               If Pos('jm',IDStr)=1 Then ArchiveType := XdiType
               Else
                 If Pos('xpa',IDStr)=1 Then ArchiveType := XpaType
               Else
                 If Pos('Õ jm',IDStr)=1 Then ArchiveType := XpdType;
               Exit;
             End;
           If Pos('xpa'#0#1,IDStr)=1 Then
             Begin
               ArchiveType := Xpa32Type;
               Exit;
             End;
           If Pos(#26#0#0#0,IDStr)=19 Then
             Begin
               ArchiveType := FlhType;
               Exit;
             End;
           If Pos('.ARI',CapStr(ArcName))<>0 Then
             Begin
               ArchiveType := AriType;
               Exit;
             End;
           If Pos('.TAR',CapStr(ArcName))<>0 Then
             Begin
               ArchiveType := TarType;
               Exit;
             End;
           If Pos('.CAR',CapStr(ArcName))<>0 Then
             Begin
               ArchiveType := CaCType;
               Exit;
             End;
           If (Pos('SZ'#10#4,IDStr)=1)

              {** Support fÅr Ñltere szip-Dateien entfernt.
                  Support for older szip files dropped.

              Or (* szip ab 1.10 *)
              (((Pos(#0,IDStr)=2) And (IDStr[1] In [#0..#21])) Or  (* szip 1.04 *)
              ((IDStr[1] In [#0..#41]) And (IDStr[2] In [#0,#3..#255]) And (IDStr[4]=#0)))
              And (* szip 1.05 *)
              (Pos('.EXE',CapStr(ArcName))=0) and (Pos('.ICO',CapStr(ArcName))=0) **}

             then
             Begin
               ArchiveType := SzipType;
               Exit;
             End;
           If Pos('.LBR',CapStr(ArcName))<>0 Then
             Begin
               ArchiveType := LBRType;
               Exit;
             End;
           ArchiveType := ArcMethod(ArcName);
         End;
     End;
 End;

End.
